#include<string>
#include<iostream>
#include<fstream>
#include<vector>
#include<math.h>
#include<climits>

std::vector<std::string> split(std::string s, std::string del = " ") {
    std::vector<std::string> split;
    int start = 0;
    int end = s.find(del);
    while (end != -1) {
        split.push_back( s.substr(start, end - start));
        //std::cout << s.substr(start, end - start) << std::endl;
        start = end + del.size();
        end = s.find(del, start);
    }
    split.push_back( s.substr(start, end - start));

    return split;
}

int main () {
    std::string input;
    std::ifstream inputFile ("../input/day7.txt");
    
    inputFile >> input;

    std::vector<std::string> stringValues = split(input, ",");

    std::vector<int> values;

    for (std::string value : stringValues) {
        values.push_back(stoi(value));
    }

    std::vector<int> fuelUsage;


    for (int target = 0; target < values.size(); target++) {
        int totalFuel = 0;
        for (int value : values) {
            totalFuel += abs(value - target);
        }
        fuelUsage.push_back(totalFuel);
    }


    int minUsage = INT_MAX;
    for (int usage : fuelUsage) {
        if (usage < minUsage) {
            minUsage = usage;
        }
    }

    std::cout << "Min fuel usage: " << minUsage << std::endl;
    
}

