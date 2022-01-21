import os, sys

import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import torch.nn.functional as F
import threading



import resnet
from model import Net, apply_attention, tile_2d_over_nd


device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

class ResNetLayer4(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.r_model = resnet.resnet152(pretrained=True)
        self.r_model.eval()
        self.r_model.to(device)

        self.buffer = {}
        lock = threading.Lock()

        # Since we only use the output of the 4th layer from the resnet model and do not
        # need to do forward pass all the way to the final layer we can terminate forward
        # execution in the forward hook of that layer after obtaining the output of it.
        # For that reason, we can define a custom Exception class that will be used for
        # raising early termination error.
        def save_output(module, input, output):
            with lock:
                self.buffer[output.device] = output

        self.r_model.layer4.register_forward_hook(save_output)

    def forward(self, x):
        self.r_model(x)          
        return self.buffer[x.device]

class VQA_Resnet_Model(Net):
    def __init__(self, embedding_tokens):
        super().__init__(embedding_tokens)
        self.resnet_layer4 = ResNetLayer4()
    
    def forward(self, v, q, q_len):
        q = self.text(q, list(q_len.data))
        v = self.resnet_layer4(v)

        v = v / (v.norm(p=2, dim=1, keepdim=True).expand_as(v) + 1e-8)

        a = self.attention(v, q)
        v = apply_attention(v, a)

        combined = torch.cat([v, q], dim=1)
        answer = self.classifier(combined)
        return answer

def load_model():
    saved_state = torch.load('2017-08-04_00.55.19.pth', map_location=device)

    vocab = saved_state['vocab']

    # reading word tokens from saved model
    token_to_index = vocab['question']
    num_tokens = len(token_to_index) + 1
    vqa_net = torch.nn.DataParallel(Net(num_tokens))
    vqa_net.load_state_dict(saved_state['weights'])
    vqa_net.to(device)
    vqa_net.eval()
    
    vqa_resnet = VQA_Resnet_Model(vqa_net.module.text.embedding.num_embeddings)

    vqa_resnet.text.load_state_dict(vqa_net.module.text.state_dict())
    vqa_resnet.attention.load_state_dict(vqa_net.module.attention.state_dict())
    vqa_resnet.classifier.load_state_dict(vqa_net.module.classifier.state_dict())
    
    vqa_resnet.to(device)
    vqa_resnet.eval()
    
    return vqa_resnet
