#!/usr/bin/env python3

import sys
import argparse
import json
import turtle
import networkx as nx
from utd_turtle import *
from utd_astar import *
from utd_weighted import *
from utd_depth_first_search import *
from utd_breadth_first_search import *
from utd_graph import *

# Student needs to implement this function
def hcost(G,a,b):
        # Three arguments: graph, node1, node2
	#  Student needs to calculate proper distance
	#  between these two nodes
        dist = 0
        return dist


def main( filename ):
    width = 800
    height = 800
    t = utDturtle_init( width, height ) 
    screen = t.screen

    min_x, min_y, max_x, max_y = t.bbox # get the furthest points the turtle has been
    width = max((0-min_x),(max_x)) * 2 + 100 # work out what the maximum distance from 0,0 is for each axis
    height = max((0-min_y),(max_y)) * 2 + 100 # the 100 here gives us some padding between the edge and whats drawn
    screen.screensize(width, height)

    new_graph = read_the_graph(filename)

    xoff = 400
    yoff = 200
    source = 0
    target = 18
    t.draw_offset( xoff, yoff )
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()


    print('Hit any key to run astar search with hcost heuristic')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    astar_nodes = []
    # Student needs to implement astart search
    #  Add your code here
    #      astar_nodes = your_astar_algorithm( new_graph, source, target, turtle_obj=t )

    draw_graph_nodes( t, new_graph, astar_nodes, 'orange', 30)


    print('Hit any key to exit')
    dummy = input()

        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'filename', metavar='filename',
         nargs='?', help='the name of the graph file to read')

    args = parser.parse_args()
    filename = args.filename
    if filename == None:
        print(f'ERROR: filename required.\n')
        exit(1)
    main( filename )


