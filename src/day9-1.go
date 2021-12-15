package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

// Main function
func main() {
    colorReset := "\033[0m"

    colorGreen := "\033[32m"


    file, err := os.Open("../input/day9.txt")
    if err != nil {
        panic("Couldn't open file")
    }
    defer file.Close()

    var depths[][] int

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        var row[] int
        for _, char := range scanner.Text() {
            i, err := strconv.Atoi(string(char))
            if err != nil {
                panic("Couldn't convert string to int")
            }

            row = append(row, i)
        }
        depths = append(depths, row)
    }

    total := 0

    for row_index, row := range depths {
        for item_index, i := range row {
            // Above
            if row_index > 0 && depths[row_index - 1][item_index] <= i {
                fmt.Print(i)
                continue
            }
            // Below
            if row_index < len(depths) - 1 && depths[row_index + 1][item_index] <= i {
                fmt.Print(i)
                continue
            }
            // Left
            if item_index > 0 && depths[row_index][item_index - 1] <= i {
                fmt.Print(i)
                continue
            }
            // Right
            if item_index < len(depths[row_index]) - 1 && depths[row_index][item_index + 1] <= i {
                fmt.Print(i)
                continue
            }
            fmt.Printf("%s%d%s", colorGreen, i, colorReset)
            total += i + 1
        }
        fmt.Println()
    }

    fmt.Printf("Sum of risk level: %d\n", total)
}
