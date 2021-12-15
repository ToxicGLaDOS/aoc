use std::{convert::TryInto, fs};

fn increment(octopuses: &mut [[i32; 10]; 10]){
    // Increment everything by 1
    for y in 0..octopuses.len() {
        for x in 0..octopuses[y].len() {
            octopuses[y][x] += 1;
        }
    }
}

fn flash(octopuses: &mut [[i32; 10]; 10], x: usize, y: usize) -> usize {
    // Start at one to count this octopus's flash
    let mut flashes = 1;
    octopuses[y][x] = 0;
    for j in -1..2 as i32 {
        for i in -1..2 as i32{
            if i == 0 && j == 0 {
                continue;
            }

            let y_temp: i32 = y as i32 + j;
            let x_temp: i32 = x as i32 + i;
            let y_index: usize;
            let x_index: usize;

            match y_temp.try_into() {
                Ok(n) => y_index = n,
                Err(_) => continue,
            }

            match x_temp.try_into() {
                Ok(n) => x_index = n,
                Err(_) => continue,
            }

            if y_index < octopuses.len() && x_index < octopuses.len() {
                // Incrementing happens first so we only see a 0
                // when this octopus flashed already, so we don't need to
                // charge those octopuses
                if octopuses[y_index][x_index] != 0 {
                    octopuses[y_index][x_index] += 1;
                }
                if octopuses[y_index][x_index] > 9 {
                    flashes += flash(octopuses, x_index, y_index);
                }
            }
            
        }
    }

    return flashes;
}

fn main() {

    let mut octopuses: [[i32; 10]; 10] = [[0;10]; 10];

    let input = fs::read_to_string("../input/day11.txt")
        .expect("Something went wrong reading the file");

    for (y, line) in input.split("\n").enumerate() {
        for (x, c) in line.chars().enumerate() {
            octopuses[y][x] = c as i32 - 0x30
        }
    }

    let mut flashes = 0;

    for i in 0..100 {
        // Increment by 1
        increment(&mut octopuses);

        // Flash all the octopuses above 9
        for y in 0..octopuses.len() {
            for x in 0..octopuses[y].len() {
                if octopuses[y][x] > 9 {
                    flashes += flash(&mut octopuses, x, y);
                }
            }
        }

        // Print board
        println!();
        for row in octopuses.iter() {
            for value in row.iter() {
                print!("{}", value);
            }
            println!();
        }
    }
    println!("{} flashes", flashes);
}

