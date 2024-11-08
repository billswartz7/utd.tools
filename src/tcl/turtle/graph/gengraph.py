
import argparse
import json
import networkx as nx
from networkx.drawing.nx_pydot import write_dot


def main(filename,num_nodes,threshold):
    print(f'User requested a random graph with {num_nodes} nodes with threshold:{threshold} ')    
    print(f'Output filename: {filename}\n')    

    our_graph = nx.random_geometric_graph(num_nodes, threshold)
    print(f'The graph has {our_graph.size()} edges and {our_graph.order()} nodes')
    print(f'The graph nodes {our_graph.nodes()}')
    print(f'Node data {our_graph.nodes.data()}')
    edges = our_graph.edges
    num_edges = our_graph.number_of_edges()
    print(f'Edge data:{edges}')
    e = 0 ;
    edge_info = {}
    for edge in edges:
      # print(f'Edge data {e} {edge}')
      edge_info[e] = edge
      e = e + 1

    print(f'Edge info {edge_info}')
    pos = nx.nx_pydot.graphviz_layout(our_graph, prog='dot', root='0')
    print(f'Pos: {pos}')
    num_nodes = len(pos)

    print(f'Dump the graph to {filename}...')
    graph_data = {
        'num_nodes': num_nodes,
        'nodes': pos,
        'num_edges': num_edges,
	'edges': edge_info
    }
    with open(filename, 'w') as fp:
        json.dump(graph_data, fp, sort_keys=False, indent=4)

if __name__ == '__main__':
    num_nodes = 20
    threshold = 0.4
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'filename', metavar='filename',
         nargs='?', help='the name of the file to generate')
    parser.add_argument( '-number', '-n',
         help='Set the number of nodes in graph', required=False)
    parser.add_argument( '-threshold', '-t',
         help='Set connective threshold [0..1.0]', required=False)

    args = parser.parse_args()
    filename = args.filename
    print(args)
    if filename == None:
        print(f'ERROR: filename required.\n')
        exit(1)
    if args.number != None:
        num_nodes = int(args.number)
    if args.threshold != None:
        threshold = float(args.threshold)
    main( filename, num_nodes, threshold )
