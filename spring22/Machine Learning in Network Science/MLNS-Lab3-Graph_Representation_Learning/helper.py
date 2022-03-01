#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
"""
import numpy as np
import networkx as nx
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.sparse import *
from sklearn.manifold import TSNE
from sklearn.multiclass import OneVsRestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.linear_model import LogisticRegression
from sklearn.utils import shuffle
from sklearn.metrics import f1_score
from sklearn.metrics import roc_curve, auc

def get_node2community(g):
    node2comm = nx.get_node_attributes(g,'community')
    num_of_communities = 0
    for node in node2comm:
        if type(node2comm[node]) is not list:
            node2comm[node] = [node2comm[node]]

        if max(node2comm[node]) > num_of_communities:
            num_of_communities = max(node2comm[node])

    num_of_communities += 1
    
    return node2comm, num_of_communities

def visualize(graph, node2embedding):
    
    node2comm, num_of_communities = get_node2community(graph)
    
    # Get the node list of the graph
    nodelist = list(graph.nodes())

    # Embedding vectors
    x = np.asarray([node2embedding[node] for node in nodelist])
    # Community labels of nodes
    y = np.asarray([node2comm[node][0] for node in nodelist])

    tsne = TSNE(n_components=2, verbose=0)
    tsne_results = tsne.fit_transform(x)

    df = pd.DataFrame({"Axis 1": x[:, 0], "Axis 2": x[:, 1], "Community": y})

    plt.figure(figsize=(6,6))
    sns.scatterplot(
        x="Axis 1", y="Axis 2",
        palette=sns.color_palette("hls", num_of_communities),
        data=df,
        hue=y,
        alpha=0.8
    )

def classification(graph, train_set_ratio, node2embedding, number_of_shuffles):
    
    _score_types = ['micro', 'macro']
    # Get the ground-truth labels and and the total number of labels
    node2community, K = get_node2community(graph)

    N = graph.number_of_nodes()

    nodelist = list(graph.nodes())
    x = np.asarray([node2embedding[node] for node in nodelist])
    label_matrix = csr_matrix([[1 if k in node2community[node] else 0 for k in range(K)] for node in nodelist])

    results = {score_t: [] for score_t in _score_types}

    # Get the training size
    train_set_size = int(train_set_ratio * N)        
            
    for _ in range(number_of_shuffles):
        
        # Shuffle the data
        shuffled_features, shuffled_labels = shuffle(x, label_matrix)

        # Divide the data into the training and test sets
        train_features = shuffled_features[0:train_set_size, :]
        train_labels = shuffled_labels[0:train_set_size]

        test_features = shuffled_features[train_set_size:, :]
        test_labels = shuffled_labels[train_set_size:]
        
        # Build the model and train it
        ovr = OneVsRestClassifier(LogisticRegression(solver='liblinear'))
        ovr.fit(train_features, train_labels)

        # Find the predictions, each node can have multiple labels
        test_prob = np.asarray(ovr.predict_proba(test_features))
        y_pred = []
        for i in range(test_labels.shape[0]):
            k = test_labels[i].getnnz()  # The number of labels to be predicted
            pred = test_prob[i, :].argsort()[-k:]
            y_pred.append(pred)

        # Find the true labels
        y_true = [[] for _ in range(test_labels.shape[0])]
        co = test_labels.tocoo()
        for i, j in zip(co.row, co.col):
            y_true[i].append(j)

        mlb = MultiLabelBinarizer(range(K))
        for score_t in _score_types:
            score = f1_score(y_true=mlb.fit_transform(y_true), y_pred=mlb.fit_transform(y_pred), average=score_t)
            results[score_t].append(score)
    
    average_results = {score_t: np.mean(results[score_t]) for score_t in _score_types}
        
    return average_results

