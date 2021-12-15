#!/usr/bin/env ruby

$openers = ['(', '[', '{', '<']
$closers = [')', ']', '}', '>']

$mapping = Hash['(' => ')', '[' => ']', '{' => '}', '<' => '>']
points = Hash[')' => 3, ']' => 57, '}' => 1197, '>' => 25137]

pointSum = 0

def getCorruption(string)
  stack = []
  string.each_char {|char|
    print char
    if $openers.include?(char)
      stack.push(char)
    else
      if char == "\n"
        # Incomplete, but not corrupted
      elsif char != $mapping[stack[-1]]
        print "\n#{stack}\n"
        puts "Expected #{$mapping[stack[-1]]} got '#{char}'"
        return char
      else
        stack.pop()
      end
    end
  }
  return nil
end

IO.foreach("../input/day10.txt"){|line|
  puts line
  errorChar = getCorruption(line)
  if errorChar != nil
    pointSum += points[errorChar]
  end
}

puts "Syntax error score: #{pointSum}"
