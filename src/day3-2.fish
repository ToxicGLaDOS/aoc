#!/usr/bin/env fish
set len 12

set gamma ""

set epsilon ""



set input (string split ' ' (cat '../input/day3-1.txt'))

function only_greatest
    set digit $argv[1]
    set inp $argv[2..]

    # Break early if there is only one candidate
    if test (count $inp) -eq 1
        echo $inp
        return
    end

    set one_count 0
    set zero_count 0

    for measure in $inp
        if test (echo $measure | head -c $digit | tail -c 1) = 0
            set zero_count (math $zero_count + 1)
        else
            set one_count (math $one_count + 1)
        end
    end


    set candidates

    for measure in $inp
        if test $one_count -ge $zero_count
            if test (echo $measure | head -c $digit | tail -c 1) = 0
            else
                set -a candidates $measure
            end
        else if test $zero_count -gt $one_count
            if test (echo $measure | head -c $digit | tail -c 1) = 0
                set -a candidates $measure
            else
            end
        end
    end

    echo $candidates
end

function only_lowest
    set digit $argv[1]
    set inp $argv[2..]

    # Break early if there is only one candidate
    if test (count $inp) -eq 1
        echo $inp
        return
    end
    set one_count 0
    set zero_count 0

    for measure in $inp
        if test (echo $measure | head -c $digit | tail -c 1) = 0
            set zero_count (math $zero_count + 1)
        else
            set one_count (math $one_count + 1)
        end
    end


    set candidates

    for measure in $inp
        if test $one_count -ge $zero_count
            if test (echo $measure | head -c $digit | tail -c 1) = 0
                set -a candidates $measure
            else
            end
        else if test $zero_count -gt $one_count
            if test (echo $measure | head -c $digit | tail -c 1) = 0
            else
                set -a candidates $measure
            end
        end
    end

    echo $candidates
end


set oxygen_generator_candidates (only_greatest 1 $input | tr ' ' '\n')
set CO2_scrubber_candidates (only_lowest 1 $input | tr ' ' '\n')


for x in (seq 2 12)
    set oxygen_generator_candidates (only_greatest $x $oxygen_generator_candidates | tr ' ' '\n')
    set CO2_scrubber_candidates (only_lowest $x $CO2_scrubber_candidates | tr ' ' '\n')
end 

set dec_oxygen (echo "obase=10; ibase=2; $oxygen_generator_candidates" | bc)
set dec_co2 (echo "obase=10; ibase=2; $CO2_scrubber_candidates" | bc)
set product (math "$dec_oxygen*$dec_co2")

echo "Oxygen generator rating: $oxygen_generator_candidates, CO2 scrubber rating: $CO2_scrubber_candidates, Product: $product"


#for x in (seq 12)
#
#    while read line
#        if test (echo $line | head -c $x | tail -c 1) = 0
#            set zero_count (math $zero_count + 1)
#        else
#            set one_count (math $one_count + 1)
#        end
#    end < "../input/day3-1.txt"
#
#    if test $one_count -gt $zero_count
#        set gamma $gamma"1"
#        set epsilon $epsilon"0"
#    else
#        set gamma $gamma"0"
#        set epsilon $epsilon"1"
#    end
#    set one_count 0
#    set zero_count 0
#end
#
#set dec_gamma (echo "obase=10; ibase=2; $gamma" | bc)
#set dec_epsilon (echo "obase=10; ibase=2; $epsilon" | bc)
#set product (math "$dec_gamma*$dec_epsilon")
#
#echo "Gamma: $gamma, Epsilon $epsilon, Product: $product"
