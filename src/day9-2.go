package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
)

const (
    colorReset = "\033[0m"
    colorGreen = "\033[32m"
)

type point struct {
    x int
    y int
}

func contains(points[] point, checkPoint point) bool {
    for _, point := range points {
        if point == checkPoint {
            return true
        }
    }
    return false
}

func isLowPoint(depths[][] int, point point) bool{
    x := point.x
    y := point.y
    i := depths[y][x]

    // Above
    if y > 0 && depths[y - 1][x] <= i {
        fmt.Print(i)
        return false
    }
    // Below
    if y < len(depths) - 1 && depths[y + 1][x] <= i {
        fmt.Print(i)
        return false
    }
    // Left
    if x > 0 && depths[y][x - 1] <= i {
        fmt.Print(i)
        return false
    }
    // Right
    if x < len(depths[y]) - 1 && depths[y][x + 1] <= i {
        fmt.Print(i)
        return false
    }
    fmt.Printf("%s%d%s", colorGreen, i, colorReset)
    return true
}

func getBasin(depths[][] int, curPoint point, basin[] point) []point{
    x := curPoint.x
    y := curPoint.y
    i := depths[y][x]

    basin = append(basin, curPoint)

    // Above
    if y > 0 && depths[y - 1][x] >= i && depths[y - 1][x] != 9 && !contains(basin, point{x, y - 1}){
        basin = getBasin(depths, point{x, y - 1}, basin)
    }
    // Below
    if y < len(depths) - 1 && depths[y + 1][x] >= i && depths[y + 1][x] != 9 && !contains(basin, point{x, y + 1}) {
        basin = getBasin(depths, point{x, y + 1}, basin)
    }
    // Left
    if x > 0 && depths[y][x - 1] >= i && depths[y][x - 1] != 9 && !contains(basin, point{x - 1, y}){
        basin = getBasin(depths, point{x - 1, y}, basin)
    }
    // Right
    if x < len(depths[y]) - 1 && depths[y][x + 1] >= i && depths[y][x + 1] != 9 && !contains(basin, point{x + 1, y}){
        basin = getBasin(depths, point{x + 1, y}, basin)
    }

    return basin
}

// Main function
func main() {
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
            fmt.Print(string(char))

            row = append(row, i)
        }
        fmt.Println()
        depths = append(depths, row)
    }

    var basins[][] point;

    for y, row := range depths {
        for x, _ := range row {
            if isLowPoint(depths, point{x, y}) {
                var basin[] point
                basin = getBasin(depths, point{x, y}, basin)
                basins = append(basins, basin)
            }
        }
        fmt.Println()
    }

    sort.Slice(basins, func(i, j int) bool {
        return len(basins[i]) < len(basins[j])
    })


    for _, basin := range basins[len(basins) - 3:] {
        fmt.Println(basin)
    }
    
    product := 1
    for _, basin := range basins[len(basins) - 3:] {
        product *= len(basin)
    }

    fmt.Printf("Product of 3 largest basin sizes: %d\n", product)
    
}

func testContains () {
    var points[] point;

    p1 := point{0, 0}
    p2 := point{1, 0}
    p3 := point{2, 0}
    p4 := point{3, 0}

    points = append(points, p1)
    points = append(points, p2)
    points = append(points, p3)
    points = append(points, p4)
    if !contains(points, point{0, 0}) {
        panic("Should contain")
    }
    if contains(points, point{5, 0}) {
        panic("Should not contain")
    }
    fmt.Println()
}
