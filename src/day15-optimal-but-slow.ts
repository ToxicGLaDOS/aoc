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

function pathContains(path: Point[], point: Point): boolean {
    return path.findIndex((curPoint: Point) => {
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

// This heuristic basically assumes that the rest of the path is 1's
function heuristic(map : number[][], path: Point[]) {
    let cost = getCost(map, path);
    let lastPoint : Point = path[path.length - 1];
    return cost + (map.length - 1) - lastPoint.x + (map.length - 1) - lastPoint.y
}

fs.readFile('../input/day15-test.txt', (err: object, data: string) => {
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

    let paths: Point[][] = [];
    let start: Point = new Point(0, 0);
    // Seed paths with just the starting point
    paths.push([start]);

    while (true) {
        let path: Point[]|undefined = paths[0];
        if (path == undefined) throw "Ran out of paths???";

        let lastPoint: Point = path[path.length-1];
        let posX: Point = new Point(lastPoint.x+1, lastPoint.y);
        let negX: Point = new Point(lastPoint.x-1, lastPoint.y);
        let posY: Point = new Point(lastPoint.x, lastPoint.y+1);
        let negY: Point = new Point(lastPoint.x, lastPoint.y-1);

        if (lastPoint.x == map.length - 1 && lastPoint.y == map.length - 1) {
            console.log(path);
            console.log("Cost: " + getCost(map, path));
            break;
        }

        // Assumes map is square
        if (posX.x < map.length && !pathContains(path, posX)) {
            let pathCopy: Point[] = [...path];
            pathCopy.push(posX);
            paths.push(pathCopy);
        }
        if (negX.x >= 0 && !pathContains(path, negX)) {
            let pathCopy: Point[] = [...path];
            pathCopy.push(negX);
            paths.push(pathCopy);
        }
        if (posY.y < map.length && !pathContains(path, posY)) {
            let pathCopy: Point[] = [...path];
            pathCopy.push(posY);
            paths.push(pathCopy);
        }
        if (negY.y >= 0 && !pathContains(path, negY)) {
            let pathCopy: Point[] = [...path];
            pathCopy.push(negY);
            paths.push(pathCopy);
        }

        // Pop the first path
        paths.shift();

        if (paths.length % 1000 == 0) {
            console.log(paths.length);
            //console.log(paths);
        }

        // A*?
        paths.sort((a: Point[], b: Point[]) => {
            return heuristic(map, a) - heuristic(map, b);
        });
    }
})


let message: string = 'Hello, World!';
console.log(message);
