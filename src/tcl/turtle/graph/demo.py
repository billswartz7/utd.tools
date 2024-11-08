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

def hcost(G,a,b):
        pt = G.nodes[a]['position']
        x1 = pt[0]
        y1 = pt[1]
        pt2 = G.nodes[b]['position']
        x2 = pt2[0]
        y2 = pt2[1]
        dist = abs(x1 - x2) + abs(y1 - y2)
        print(f' dist: {dist}' )
        return dist


def main( filename ):
    width = 400
    height = 400
    t = utDturtle_init( width, height ) 
    screen = t.screen
    width,height = screen.screensize()
    # t.border( width, height )

    min_x, min_y, max_x, max_y = t.bbox # get the furthest points the turtle has been
    width = max((0-min_x),(max_x)) * 2 + 100 # work out what the maximum distance from 0,0 is for each axis
    height = max((0-min_y),(max_y)) * 2 + 100 # the 100 here gives us some padding between the edge and whats drawn
    # screen.screensize(width, height)

    # Uncomment to draw the graphics as quickly as possible.
    ##t.speed(0)

    new_graph = read_the_graph(filename)

    # t.draw_dot( 0, 0, 20, 'green' )

    xoff = 400
    yoff = 200
    source = 0
    target = 18
    t.draw_offset( xoff, yoff )
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()

    print('Hit any key to depth-first search')
    dummy = input()
    turtle.tracer(1,25)
    dfs_edges = utd_dfs_edges( new_graph, source, turtle_obj=t )
    draw_graph_edges( t, new_graph, dfs_edges, 'purple', 8)
    turtle.update()

    print('Hit any key to run breadth-first search display by edge expansion')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    bfs_edges = []
    for edge in utd_bfs_edges( new_graph, source ):
        bfs_edges.append(edge)

    draw_graph_edges( t, new_graph, bfs_edges, 'purple', 8)
    turtle.update()

    print('Hit any key to run breadth-first search by showing coloring')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    utd_bfs_nodes( new_graph, source, turtle_obj=t )
    turtle.update()

    print('Hit any key to run astar search without hcost heuristic')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    astar_nodes = utd_astar_path( new_graph, source, target, turtle_obj=t )
    astar_nodes.reverse()
    print(f'Astar nodes: {astar_nodes} ')
    turtle.tracer(1,25)
    draw_graph_nodes( t, new_graph, astar_nodes, 'orange', 30)
    turtle.update()

    print('Hit any key to run astar search with hcost heuristic')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    astar_nodes = utd_astar_path( new_graph, source, target, turtle_obj=t, heuristic=hcost )
    astar_nodes.reverse()
    draw_graph_nodes( t, new_graph, astar_nodes, 'orange', 30)

    print('Hit any key to run Dijstra shortest path search')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    astar_nodes = utd_dijkstra_path( new_graph, source, target, turtle_obj=t )
    astar_nodes.reverse()
    print(f'Dijstra path nodes: {astar_nodes} ')
    draw_graph_nodes( t, new_graph, astar_nodes, 'orange', 30)
    turtle.update()

    print('Hit any key to run bidiretional Dijstra shortest path search')
    dummy = input()
    turtle.clearscreen()
    turtle.tracer(0,0)
    draw_the_graph( t, new_graph )
    turtle.update()
    turtle.tracer(1,25)
    (path_len,astar_nodes) = utd_bidirectional_dijkstra( new_graph, source, target, turtle_obj=t )
    astar_nodes.reverse()
    print(f'Shortest path {path_len} nodes: {astar_nodes} ')
    draw_graph_nodes( t, new_graph, astar_nodes, 'orange', 30)
    turtle.update()


    print('Hit any key to exit')
    dummy = input()
    turtle.bye()

        
if __name__ == '__main__':
    if  sys.argv[0] == "twpython":
        sys.argv[1] = sys.argv[-1] 
        del sys.argv[2:]
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


