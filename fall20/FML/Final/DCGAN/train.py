import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat
from urllib.request import urlretrieve
from os.path import isfile, isdir
from tqdm import tqdm
import os
import cv2


from model import GAN, generator
from dataset import Dataset,view_samples

data_dir = 'data/'
real_size = (128,128,3)
z_size = 100
learning_rate = 0.0002
batch_size = 64
epochs = 25
alpha = 0.2
beta1 = 0.5

if not isdir(data_dir):
    raise Exception("Data directory doesn't exist!")

print("finding data")
images=np.array([cv2.resize((cv2.imread(data_dir+tmp, cv2.IMREAD_COLOR)),(128, 128))
                                               for tmp in os.listdir(data_dir)])
four_fifths = int(len(images)*(4/5))
trainset = images[:four_fifths]
testset = images[four_fifths:]
print("found data")
print("test data length", len(testset))

idx = np.random.randint(0, len(trainset), size=36)
fig, axes = plt.subplots(6, 6, sharex=True, sharey=True, figsize=(5,5),)
for ii, ax in zip(idx, axes.flatten()):
    ax.imshow(trainset[ii], aspect='equal')
    ax.xaxis.set_visible(False)
    ax.yaxis.set_visible(False)
    
plt.subplots_adjust(wspace=0, hspace=0)
print("show")
#plt.show()

print("training data")
def train(net, dataset, epochs, batch_size, print_every=5, show_every=10, figsize=(5,5)):
    saver = tf.train.Saver()
    sample_z = np.random.uniform(-1, 1, size=(72, z_size))

    samples, losses = [], []
    steps = 0
    print("starting session")
    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        for e in range(epochs):
            for x in dataset.batches(batch_size):
                steps += 1

                # Sample random noise for G
                batch_z = np.random.uniform(-1, 1, size=(batch_size, z_size))
                
                # Run optimizers
                _ = sess.run(net.d_opt, feed_dict={net.input_real: x, net.input_z: batch_z})
                _ = sess.run(net.g_opt, feed_dict={net.input_z: batch_z, net.input_real: x})
                print("epoch #%d done optimizing" %e)

                if steps % print_every == 0:
                    # At the end of each epoch, get the losses and print them out
                    train_loss_d = net.d_loss.eval({net.input_z: batch_z, net.input_real: x})
                    train_loss_g = net.g_loss.eval({net.input_z: batch_z})

                    print("Epoch {}/{}...".format(e+1, epochs),
                          "Discriminator Loss: {:.4f}...".format(train_loss_d),
                          "Generator Loss: {:.4f}".format(train_loss_g))
                    # Save losses to view after training
                    losses.append((train_loss_d, train_loss_g))

                if steps % show_every == 0:
                    gen_samples = sess.run(
                                   generator(net.input_z, 3, reuse=True, training=False),
                                   feed_dict={net.input_z: sample_z})
                    samples.append(gen_samples)
                    _ = view_samples(-1, samples, 6, 12, figsize=figsize)
                    plt.show()
        print("saving")
        saver.save(sess, './checkpoints/generator.ckpt')

    with open('samples.pkl', 'wb') as f:
        pkl.dump(samples, f)
    
    return losses, samples



# Create the network
net = GAN(real_size, z_size, learning_rate, alpha=alpha, beta1=beta1)


dataset = Dataset(trainset, testset)

losses, samples = train(net, dataset, epochs, batch_size, figsize=(10,5))

_ = view_samples(0, samples, 4, 4, figsize=(10,5))




