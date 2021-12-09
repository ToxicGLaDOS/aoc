
class LanterFish {
    int spawnTime;

    public LanterFish(int spawnTime) {
        this.spawnTime = spawnTime
    }

    public LanterFish spawn() {
        spawnTime -= 1
        if (spawnTime == -1) {
            spawnTime = 6
            return new LanterFish(8)
        }

        return null
    }

}

File file = new File("../input/day6.txt")

def input = file.text

def spawnTimes = input.split(",")

def lanterFishes = []

for ( spawnTime in spawnTimes)  {
    lanterFishes.add(new LanterFish(spawnTime as Integer))
}

for (lanterFish in lanterFishes) {
    print lanterFish.spawnTime + ','
}
println ''
println ''

for (int i = 0; i < 80; i++) {
    def newFishes = []
    for (lanterFish in lanterFishes) {
        def newFish = lanterFish.spawn()
        if (newFish != null) {
            newFishes.add(newFish)
        }
    }
    lanterFishes.addAll(newFishes)
}

//for (lanterFish in lanterFishes) {
//    print lanterFish.spawnTime + ','
//}
//println ''

println lanterFishes.size()
