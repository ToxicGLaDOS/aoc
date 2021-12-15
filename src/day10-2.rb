#!/usr/bin/env ruby

$openers = ['(', '[', '{', '<']
$closers = [')', ']', '}', '>']

$mapping = Hash['(' => ')', '[' => ']', '{' => '}', '<' => '>']
$points = Hash[')' => 1, ']' => 2, '}' => 3, '>' => 4]

$scores = []

def closeOpeners(stack)
  queue = []

  # Reverse the stack so that the top of the stack is first
  stack.reverse().each do |char|
    queue.push($mapping[char])
  end

  return queue
end

def getCompletion(string)
  stack = []
  string.each_char {|char|
    print char
    if $openers.include?(char)
      stack.push(char)
    else
      if char == "\n"
        return closeOpeners(stack)
      elsif char != $mapping[stack[-1]]
        # Corrupted but not incomplete
        return nil
      else
        stack.pop()
      end
    end
  }
  return nil
end

def scoreClosers (finishingClosers)
  score = 0
  finishingClosers.each{ |closer|
    score *= 5
    score += $points[closer]
  }
  return score
end

def test ()
  testcases = ["[({(<(())[]>[[{[]{<()<>>\n", "[(()[<>])]({[<{<<[]>>(\n", "(((({<>}<{<{<>}{[]{[]{}\n", "{<[[]]>}<{[{[{[]{()[[[]\n", "<{([{{}}[<[[[<>{}]]]>[]]\n"]
  testcases.each {|line|
    finishingClosers = getCompletion(line)
    if finishingClosers != nil
      print "#{finishingClosers}\n"
      score = scoreClosers(finishingClosers)
      puts score
      $scores.push(score)
    end

  }

  $scores.sort!
  print $scores
  puts
  
  puts "Middle value: #{$scores[$scores.length / 2]}"
end

def actuallyDoIt()
  IO.foreach("../input/day10.txt"){|line|
    puts line
    finishingClosers = getCompletion(line)
    if finishingClosers != nil
      print "#{finishingClosers}\n"
      score = scoreClosers(finishingClosers)
      puts score
      $scores.push(score)
    end
  }

  #print $scores
  # Sorts in place
  $scores.sort!
  print $scores
  puts

  # Division is integer division
  puts "Middle value: #{$scores[$scores.length / 2]}"
end

actuallyDoIt
