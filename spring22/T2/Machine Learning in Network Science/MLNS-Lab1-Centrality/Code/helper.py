#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Lab 1 - Centrality
"""
import matplotlib.pyplot as plt
import networkx as nx
import numpy as np


def visualize(graph, values, node_size=100):
    '''
    :param graph:
    :param node_list: dictionary keyed by node
    :return:
    '''
    nodes = graph.nodes()
    colors = [values[node] for node in nodes]
    
    pos = nx.spring_layout(graph)
    nx.draw_networkx_edges(graph, pos, alpha=0.2)
    nc = nx.draw_networkx_nodes(graph, pos, nodelist=nodes, node_color=colors, 
                                with_labels=False, node_size=node_size, cmap=plt.cm.jet)
    plt.colorbar(nc)
    plt.axis('off')
    
    plt.show()


def assign_random_values(graph, min_value=0, max_value=None, replace=False):
    
    if max_value is None:
        max_value = graph.number_of_nodes()
    
    values = np.random.choice(range(min_value, max_value), 
                                    size=graph.number_of_nodes(), replace=replace)
    
    node2values = {node: values[i] for i, node in enumerate(graph.nodes())}                     
    
    return node2values