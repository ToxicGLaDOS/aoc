#!/usr/bin/env -S deno --unstable run --allow-read
// We need --unstable because a bunch of the stuff
// in the deno standard library is unstable I guess?
import { createRequire } from "https://deno.land/std@0.119.0/node/module.ts";

const require = createRequire(import.meta.url);
const fs = require('fs');


class Point {
    public x: number;
    public y: number;

    constructor(x: number, y: number) {
        this.x = x;
        this.y = y;
    }
}

class Path {
    public points: Point[] = [];
    public cost: number = 0;
    public map: number[][] = [];

    constructor(map: number[][], points : Point[] = []) {
        this.map = map;
        this.points = points;
        this.cost = getCost(this.map, points);
    }

    lastPoint(): Point {
        return this.points[this.points.length - 1];
    }

    addPoint(point: Point): void{
        this.points.push(point);
        this.cost += this.map[point.y][point.x];
    }

    copy(): Path{
        return new Path(this.map, [...this.points]);
    }
}

function binSearch(paths: Path[], path: Path): number{
    let min: number = 0;
    let max: number = paths.length;
    let index: number = Math.floor(max / 2);

    while (max - min > 1) {
        if (heuristic(path) > heuristic(paths[index])) {
            min = index;
            index = min + Math.ceil((max - min) / 2);
        }
        else if (heuristic(path) < heuristic(paths[index])) {
            max = index;
            index = min + Math.floor((max - min) / 2);
        }
        else{
            return index;
        }
    }

    return index;
}

class PriorityQueue {

    public paths: Path[] = [];

    constructor() {

    }

    enqueue(path: Path) {
        let index: number = binSearch(this.paths, path);

        // If no paths have greater cost then add to end
        if (index == -1) {
            index = this.paths.length;
        }

        this.paths.splice(index, 0, path);
    }

    dequeue(): Path|undefined {
        return this.paths.shift();
    }

}

function pathContains(path: Path, point: Point): boolean {
    return path.points.findIndex((curPoint: Point) => {
        return curPoint.x == point.x && curPoint.y == point.y;
    }) != -1;
}


function getCost(map : number[][], path: Point[]) {
    let cost: number = 0;
    var point: Point;
    // Slice because start doesn't count
    for (point of path.slice(1)) {
        cost += map[point.y][point.x];
    }
    return cost;
}

// Get's the cost of a path upto (and including) a given point in the path
function getCostUpto(map : number[][], path: Path, index: number) {
    console.log(path.points.slice(0, index + 1));
    return getCost(map, path.points.slice(0, index + 1));
}

// This heuristic basically assumes that the rest of the path is 1's
function heuristic(path: Path) {
    let map = path.map;
    let cost = path.cost;
    let lastPoint : Point = path.lastPoint();
    return cost + (map.length - 1) - lastPoint.x + (map.length - 1) - lastPoint.y
}

fs.readFile('../input/day15.txt', (err: object, data: string) => {
    if (err) throw err;

    let map: number[][] = [];
    var line: string;
    for (line of data.toString().split('\n')) {
        // Skip blank line at the end
        if (line == "") continue;
        let row: number[] = [];
        let char: string;
        for (char of line) {
            row.push(parseInt(char));
        }
        map.push(row);
    }

    let paths: PriorityQueue = new PriorityQueue();
    let start: Point = new Point(0, 0);
    let startPath: Path = new Path(map, [start]);
    // Seed paths with just the starting point
    paths.enqueue(startPath);

    while (true) {
        let path: Path|undefined = paths.dequeue();
        if (path == undefined) throw "Ran out of paths???";

        let lastPoint: Point = path.lastPoint();
        let posX: Point = new Point(lastPoint.x+1, lastPoint.y);
        let negX: Point = new Point(lastPoint.x-1, lastPoint.y);
        let posY: Point = new Point(lastPoint.x, lastPoint.y+1);
        let negY: Point = new Point(lastPoint.x, lastPoint.y-1);

        if (lastPoint.x == map.length - 1 && lastPoint.y == map.length - 1) {
            console.log(path.points);
            console.log("Cost: " + path.cost);
            break;
        }

        // Assumes map is square
        if (posX.x < map.length && !pathContains(path, posX)) {
            let pathCopy: Path = path.copy();
            pathCopy.addPoint(posX);
            paths.enqueue(pathCopy);
        }
        if (negX.x >= 0 && !pathContains(path, negX)) {
            let pathCopy: Path = path.copy();
            pathCopy.addPoint(negX);
            paths.enqueue(pathCopy);
        }
        if (posY.y < map.length && !pathContains(path, posY)) {
            let pathCopy: Path = path.copy();
            pathCopy.addPoint(posY);
            paths.enqueue(pathCopy);
        }
        if (negY.y >= 0 && !pathContains(path, negY)) {
            let pathCopy: Path = path.copy();
            pathCopy.addPoint(negY);
            paths.enqueue(pathCopy);
        }

        if (paths.paths.length % 1000 == 0) {
            console.log(paths.paths.length);
            //console.log(paths);
        }
    }
})
