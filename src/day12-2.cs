using System;
using System.Collections.Generic;
using System.Linq;

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

public class Node {
    public string label;
    public List<Node> connected = new List<Node>();

    public Node(string label) {
        this.label = label;
    }

    public void AddConnected(Node other) {
        connected.Add(other);
    }

    public int CountPaths(List<Node> path) {
        List<Node> newPath = new List<Node>(path);
        newPath.Add(this);
        int paths = 0;
        if (label == "end") {
            //Console.WriteLine("Successful path: {0}", newPath.ToString2());
            return 1;
        }
        else {
            
            foreach (Node node in connected) {
                if (Node.CanVisit(node, newPath)) { 
                    paths += node.CountPaths(newPath);
                }
            }
        }
        
        return paths;
    }

    public static bool CanVisit(Node node, List<Node> path) {
        if (!node.IsSmall()) {
            return true;
        }
        if (!path.Contains(node)) {
            return true;
        }
        if (node.label == "start") {
            return false;
        }
        foreach (Node childNode in path) {
            if (childNode.IsSmall() && path.Where(x => x == childNode).Count() == 2) {
                // Successful path: { start, TQ, yv, TQ, ch, OF, iw, LN, bj, EG, bn, EG, ch, bj, OF, end }
                //Console.WriteLine("Already 2 in path, {0}: {1}", childNode.label, path.ToString2());
                return false;
            }
            if (childNode.IsSmall() && path.Where(x => x == childNode).Count() > 2) {
                throw new Exception("bad news");
            }
        }

        return true;
    }

    public bool IsSmall() {
        return char.IsLower(label[0]);
    }
}

public static class NodeListExtensions
{
   public static string ToString2(this List<Node> l)
   {
      string retVal = string.Empty;
      foreach (Node node in l) {
        retVal += string.Format("{0}{1}", string.IsNullOrEmpty(retVal) ? "" : ", ", node.label);
      }
      return string.IsNullOrEmpty(retVal) ? "{}" : "{ " + retVal + " }";
   }

}
