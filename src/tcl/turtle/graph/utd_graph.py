#!/usr/bin/env python3

import sys
import argparse
import json
import turtle
import networkx as nx
from utd_turtle import *

__all__ = ['read_the_graph',
           'draw_graph_edges',
           'draw_graph_nodes',
           'utd_draw_node',
           'draw_the_graph'
	   ]

def read_the_graph( filename ):
    print(f'Read the graph {filename}...')
    with open(filename, 'r') as fp:
        graph_data = json.load(fp)
    our_graph = nx.Graph()
    num_nodes = graph_data["num_nodes"]
    nodes = graph_data["nodes"]

    for nidx in range(num_nodes):
        our_graph.add_node(nidx)

    # Convert nodes from string to integer key
    position = {}
    for n in nodes:
        node_pos = nodes[n]
        position[int(n)] = node_pos

    nx.set_node_attributes(our_graph,position,'position')

    num_edges = graph_data["num_edges"]
    edges = graph_data["edges"]
    for e in edges:
        edge_nodes = edges[e]
        from_node = edge_nodes[0]
        to_node = edge_nodes[1]
        our_graph.add_edge( from_node, to_node )
        # Compute weight
        from_pt = our_graph.nodes[from_node]['position']
        to_pt = our_graph.nodes[to_node]['position']
        x1 = from_pt[0]
        y1 = from_pt[1]
        x2 = to_pt[0]
        y2 = to_pt[1]
        weight = abs(x1 - x2) + abs(y1 - y2)
        our_graph[from_node][to_node]['weight'] = weight
    return our_graph

def draw_graph_edges( turtle_obj, G, edges, color, size):
    for e in edges:
        from_node = e[0]
        from_pt = G.nodes[from_node]['position']
        to_node = e[1]
        to_pt = G.nodes[to_node]['position']
        x1 = from_pt[0]
        y1 = from_pt[1]
        x2 = to_pt[0]
        y2 = to_pt[1]
        turtle_obj.draw_line( x1, y1, x2, y2, color, size )

def draw_graph_nodes( turtle_obj, G, nodes, color, size):
    for n in nodes:
        pt = G.nodes[n]['position']
        xpos = pt[0]
        ypos = pt[1]
        turtle_obj.draw_dot( xpos, ypos, size, color )
        turtle_obj.draw_text( str(n), xpos, ypos, 'black', 'center' )

def utd_draw_node( turtle_obj, G, curnode, color,  size ):
        pt = G.nodes[curnode]['position']
        xpos = pt[0]
        ypos = pt[1]
        turtle_obj.draw_dot( xpos, ypos, size, color )

def draw_the_graph( turtle_obj, G ):
        nodes = G.nodes()
        edges = G.edges()
        # print(f'edges: {edges} ')
        # print(f'nodes: {nodes} ')
        draw_graph_edges( turtle_obj, G, edges, 'red', 2)
        draw_graph_nodes( turtle_obj, G, nodes, 'blue', 20 )
