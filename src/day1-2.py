#!/usr/bin/env python3

depth = []
depth_summed = []
increase_count = 0

with open('../input/day1-1.txt', 'r') as inp:
    for line in inp:
        depth.append(int(line))


for x,y,z in zip(depth, depth[1:], depth[2:]):
    print(x, y, z)
    depth_summed.append(x + y + z)

for x,y in zip(depth_summed, depth_summed[1:]):
    if y > x:
        increase_count += 1

print(increase_count)
