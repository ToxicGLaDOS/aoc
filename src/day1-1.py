#!/usr/bin/env python3

depth = []
increase_count = 0

with open('../input/day1-1.txt', 'r') as inp:
    for line in inp:
        depth.append(int(line))

for x,y in zip(depth, depth[1:]):
    if y > x:
        increase_count += 1

print(increase_count)
