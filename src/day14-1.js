#!/usr/bin/env node

const fs = require('fs');

fs.readFile('../input/day14.txt', (err, data) => {
    if (err) throw err;

    lines = data.toString().split("\n");
    
    sequence = lines[0];

    rules = {};

    for (line of lines.slice(2)) {
        split_line = line.split(" -> ");
        rules[split_line[0]] = split_line[1];
    }
    
    console.log(sequence);
    for (let count = 0; count < 10; count++) {
        new_sequence = "";

        for (let i = 0; i < sequence.length - 1; i++) {
            pair = sequence.slice(i, i+2);
            new_sequence += pair[0] + rules[pair];
        }
        new_sequence += sequence[sequence.length - 1];
        
        sequence = new_sequence;
    }
    console.log(sequence);

    quantities = {};

    for (char of sequence) {
        if (quantities[char]) {
            quantities[char] += 1;
        }
        else {
            quantities[char] = 1;
        }
    }
    
    max = Math.max.apply(Math, Object.values(quantities));
    min = Math.min.apply(Math, Object.values(quantities));
    
    console.log(Object.values(quantities));
    console.log(max);

    console.log(quantities);

    console.log("Max - min: " + (max - min));
});

