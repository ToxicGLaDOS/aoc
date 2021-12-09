import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.ArrayList;

class Point {
    int x, y;

    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
}


class PointPair {
    Point begin, end;

    PointPair(Point begin, Point end) {
        this.begin = begin;
        this.end = end;
    }

    public void print() {
        System.out.print(begin.x + "," + begin.y);
        System.out.print("->");
        System.out.println(end.x + "," + end.y);

    }
}

class Input {
    int maxX = 0;
    int maxY = 0;

    ArrayList<PointPair> pointPairs = new ArrayList<PointPair>();

    public Input(ArrayList<PointPair> pointPairs, int maxX, int maxY) {
        this.pointPairs = pointPairs;
        this.maxX = maxX;
        this.maxY = maxY;
    }
}

class InputReader {
    public static Input read(String path) {
        int maxX = 0;
        int maxY = 0;
        ArrayList<PointPair> pointPairs = new ArrayList<PointPair>();

        try {
          File myObj = new File(path);
          Scanner myReader = new Scanner(myObj);
          while (myReader.hasNextLine()) {
            String line = myReader.nextLine();

            line = line.replace(" ", "");
            String[] pointStrings = line.split("->");
            String[] coords = pointStrings[0].split(",");
            int x = Integer.parseInt(coords[0]);
            int y = Integer.parseInt(coords[1]);
            if (x > maxX) {
                maxX = x;
            }
            if (y > maxY) {
                maxY = y;
            }
            Point begin = new Point(x, y);

            coords = pointStrings[1].split(",");
            x = Integer.parseInt(coords[0]);
            y = Integer.parseInt(coords[1]);
            if (x > maxX) {
                maxX = x;
            }
            if (y > maxY) {
                maxY = y;
            }

            Point end = new Point(x, y);

            PointPair pair = new PointPair(begin, end);

            pointPairs.add(pair);
          }
          myReader.close();
        } catch (FileNotFoundException e) {
          System.out.println("Couldn't read file :(");
          e.printStackTrace();
        }
        return new Input(pointPairs, maxX, maxY);
    }

}

class Map {

    int[][] map;
    int maxX, maxY;

    public Map(int highestX, int highestY) {
        this.maxX = highestX + 1;
        this.maxY = highestY + 1;
        map = new int[maxX][maxY];
        for (int i = 0; i < maxX; i++) {
            for (int j = 0; j < maxY; j++) {
                map[i][j] = 0;
            }
        }
    }

    public void addLine (PointPair pair) {
        // vert line
        if (pair.begin.x == pair.end.x) {
            int smaller = Math.min(pair.begin.y, pair.end.y);
            int larger  = Math.max(pair.begin.y, pair.end.y);

            for (int i = smaller; i <= larger; i++) {
                map[pair.begin.x][i] += 1;
            }
        }
        // horz line
        else if (pair.begin.y == pair.end.y) {
            int smaller = Math.min(pair.begin.x, pair.end.x);
            int larger  = Math.max(pair.begin.x, pair.end.x);

            for (int i = smaller; i <= larger; i++) {
                map[i][pair.begin.y] += 1;
            }
        }
        else {
            pair.print();
        }
    }

    public void print() {
        for (int i = 0; i < maxX; i++) {
            for (int j = 0; j < maxY; j++) {
                System.out.print(map[j][i]);
            }
            System.out.print('\n');
        }
    }

    public int numDangerous(){
        int count = 0;
        for (int i = 0; i < maxX; i++) {
            for (int j = 0; j < maxY; j++) {
                if (map[i][j] > 1) {
                    count += 1;
                }
            }
        }

        return count;
    }
}

class Main {

    public static void main(String[] argv) {
        Input input = InputReader.read("../input/day5.txt");
        Map map = new Map(input.maxX, input.maxY);

        for (PointPair pair : input.pointPairs) {
            //System.out.print(pair.begin.x + "," + pair.begin.y);
            //System.out.print("->");
            //System.out.println(pair.end.x + "," + pair.end.y);
            map.addLine(pair);
        }

        //map.print();

        System.out.println(map.numDangerous());
        
        //for (int i = 0; i < input.maxX; i++) {
        //    for (int j = 0; j < input.maxY; j++) {
        //        System.out.print(map[i][j]);
        //    }
        //    System.out.print('\n');
        //}
    }
}

