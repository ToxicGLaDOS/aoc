#!/usr/bin/env fish

set len 12

set gamma ""

set epsilon ""

set one_count 0
set zero_count 0

for x in (seq 12)

    while read line
        if test (echo $line | head -c $x | tail -c 1) = 0
            set zero_count (math $zero_count + 1)
        else
            set one_count (math $one_count + 1)
        end
    end < "../input/day3-1.txt"

    if test $one_count -gt $zero_count
        set gamma $gamma"1"
        set epsilon $epsilon"0"
    else
        set gamma $gamma"0"
        set epsilon $epsilon"1"
    end
    set one_count 0
    set zero_count 0
end

set dec_gamma (echo "obase=10; ibase=2; $gamma" | bc)
set dec_epsilon (echo "obase=10; ibase=2; $epsilon" | bc)
set product (math "$dec_gamma*$dec_epsilon")

echo "Gamma: $gamma, Epsilon $epsilon, Product: $product"
