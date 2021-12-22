#!/usr/bin/env node

const fs = require('fs');

fs.readFile('../input/day14.txt', (err, data) => {
    if (err) throw err;

    lines = data.toString().split("\n");
    
    sequence = lines[0];

    rules = {};
    pair_counts = {};

    for (line of lines.slice(2)) {
        // Skip empty line at the end
        if (line != "") {
            split_line = line.split(" -> ");
            pair = split_line[0];
            insertion = split_line[1];
            rules[pair] = insertion;
            pair_counts[pair] = 0;
        }        
    }

    // Encode initial sequence as pairs
    for (let i = 0; i < sequence.length - 1; i++) {
        pair = sequence.slice(i, i+2);
        pair_counts[pair] += 1;
    }

    for (let i = 0; i < 40; i++) {
        // Initalize all new_pair_counts to 0
        new_pair_counts = {};
        for (pair in rules) {
            new_pair_counts[pair] = 0;
        }

        for (pair in pair_counts) {
            first_pair  = pair[0] + rules[pair];
            second_pair = rules[pair] + pair[1];
            
            // For each "pair" in the string we add 1 first_pair and
            // 1 second_pair to the next iteration
            new_pair_counts[first_pair]  += pair_counts[pair];
            new_pair_counts[second_pair] += pair_counts[pair];   
        }
        pair_counts = new_pair_counts;
    }

    quantities = {}

    for (pair in pair_counts) {
        first_letter = pair[0];
        second_letter = pair[1];
        if (quantities[first_letter]) {
            quantities[first_letter] += pair_counts[pair];
        }
        else { 
            quantities[first_letter] = pair_counts[pair];
        }
        if (quantities[second_letter]) {
            quantities[second_letter] += pair_counts[pair];
        }
        else {
            quantities[second_letter] = pair_counts[pair];
        }
    }

    for (pair in quantities) {
        // Every letter should be double counted expect for the
        // beginning and the end so we halve it and the round up
        // so the beginning and end are still counted
        // (they'll be x.5 after dividing by two and we want it to be x+1)
        quantities[pair] = Math.ceil(quantities[pair] / 2);
    }
    console.log(quantities);

    max = Math.max.apply(Math, Object.values(quantities));
    min = Math.min.apply(Math, Object.values(quantities));

    console.log("Max - min: " + (max - min));
});

