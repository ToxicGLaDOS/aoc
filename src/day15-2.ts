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

// This heuristic basically assumes that the rest of the path is 1's
function heuristic(map : number[][], point: Point) {
    return (map.length - 1) - point.x + (map.length - 1) - point.y
}

fs.readFile('../input/day15.txt', (err: object, data: string) => {
    if (err) throw err;

    let costMatrix: number[][] = [];
    let map: number[][] = [];
    var line: string;

    for (let j = 0; j < 5; j++ ){
        for (line of data.toString().split('\n')) {
            // Skip blank line at the end
            if (line == "") continue;
            let row: number[] = [];
            let infs: number[] = [];
            let char: string;
            for (let i = 0; i < 5; i++){
                for (char of line) {
                    let value: number = (parseInt(char) + i + j - 1) % 9 + 1;
                    row.push(value);
                    infs.push(Infinity);
                }    
            } 
            map.push(row);
            costMatrix.push(infs);
        }
    }

    costMatrix[0][0] = 0;
    let start: Point = new Point(0, 0);
    let open: Point[] = [start];

    while (open.length > 0) {
        let point: Point|undefined = open.shift();
        if (point == undefined) throw "Ran out of points???";
        


        let posX: Point = new Point(point.x+1, point.y);
        let negX: Point = new Point(point.x-1, point.y);
        let posY: Point = new Point(point.x, point.y+1);
        let negY: Point = new Point(point.x, point.y-1);

        if (point.x == map.length - 1 && point.y == map.length - 1) {
            //console.log(path.points);
            //console.log("Cost: " + path.cost);
            console.log("Success");
            console.log(costMatrix[costMatrix.length - 1][costMatrix.length - 1]);
            break;
        }

        // Assumes map is square
        if (posX.x < map.length && costMatrix[point.y][point.x] + map[posX.y][posX.x] < costMatrix[posX.y][posX.x]) {
            costMatrix[posX.y][posX.x] = costMatrix[point.y][point.x] + map[posX.y][posX.x];
            open.push(posX);
        }
        if (negX.x >= 0 && costMatrix[point.y][point.x] + map[negX.y][negX.x] < costMatrix[negX.y][negX.x]) {
            costMatrix[negX.y][negX.x] = costMatrix[point.y][point.x] + map[negX.y][negX.x];
            open.push(negX);
        }
        if (posY.y < map.length && costMatrix[point.y][point.x] + map[posY.y][posY.x] < costMatrix[posY.y][posY.x]) {
            costMatrix[posY.y][posY.x] = costMatrix[point.y][point.x] + map[posY.y][posY.x];
            open.push(posY);
        }
        if (negY.y >= 0 && costMatrix[point.y][point.x] + map[negY.y][negY.x] < costMatrix[negY.y][negY.x]) {
            costMatrix[negY.y][negY.x] = costMatrix[point.y][point.x] + map[negY.y][negY.x];
            open.push(negY);
        }

        open.sort((a: Point, b:Point) => {
            return heuristic(map, b) - heuristic(map, a);
        })

        //console.log(heuristic(map, open[0]));
    }
})
