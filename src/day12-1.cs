using System;
using System.Collections.Generic;

class Day12 {

    public static void Main(string[] args) {
        string[] lines = System.IO.File.ReadAllLines(@"../input/day12.txt");
        Dictionary<string, Node> nodes = new Dictionary<string, Node>();

        foreach (string line in lines) {
            Console.WriteLine(line);
            string[] labels = line.Split("-");
            string labelA = labels[0];
            string labelB = labels[1];
            Node nodeA;
            Node nodeB;

            if (nodes.ContainsKey(labelA)) {
                nodeA = nodes[labelA];
            }
            else {
                nodeA = new Node(labelA);
                nodes.Add(nodeA.label, nodeA);
            }

            if (nodes.ContainsKey(labelB)) {
                nodeB = nodes[labelB];
            }
            else {
                nodeB = new Node(labelB);
                nodes.Add(nodeB.label, nodeB);
            }
            nodeA.AddConnected(nodeB);
            nodeB.AddConnected(nodeA);
        }
        
        Node start = nodes["start"];

        int numPaths = start.CountPaths(new List<Node>());
        Console.WriteLine(String.Format("Num paths: {0}", numPaths));
    }
}

class Node {
    public string label;
    public List<Node> connected = new List<Node>();

    public Node(string label) {
        this.label = label;
    }

    public void AddConnected(Node other) {
        connected.Add(other);
    }

    public int CountPaths(List<Node> path) {
        int paths = 0;
        if (label == "end") {
            return 1;
        }
        else {
            foreach (Node node in connected) {
                if (!(node.IsSmall() && path.Contains(node))) {
                    List<Node> newPath = new List<Node>(path);
                    newPath.Add(this);
                    paths += node.CountPaths(newPath);
                }
            }
        }
        
        return paths;
    }

    public bool IsSmall() {
        return char.IsLower(label[0]);
    }
}
