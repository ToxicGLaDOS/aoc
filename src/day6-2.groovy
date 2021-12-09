def lanternFishes = [0:0l,
                    1:0l,
                    2:0l,
                    3:0l,
                    4:0l,
                    5:0l,
                    6:0l,
                    7:0l,
                    8:0l]

File file = new File("../input/day6.txt")

def input = file.text

def spawnTimes = input.split(",")

for ( spawnTime in spawnTimes)  {
    lanternFishes[spawnTime as Integer] += 1
}

//for (lanternFish in lanternFishes) {
//    println lanternFish
//}
//println ''

for (int i = 0; i < 256; i++) {
    def startingZeros = lanternFishes[0]

    // Move each group down one
    for (int spawnTime = 1; spawnTime <= 8; spawnTime++) {
        lanternFishes[spawnTime - 1] = lanternFishes[spawnTime]
    }

    // Reset all the fish that were at zero
    lanternFishes[6] += startingZeros

    // Spawn new fish
    lanternFishes[8] = startingZeros

    //for (lanternFish in lanternFishes) {
    //    println lanternFish
    //}
    //println ''
}


def sum = 0
for (int spawnTime = 0; spawnTime <= 8; spawnTime++) {
    sum += lanternFishes[spawnTime]
}


println sum

