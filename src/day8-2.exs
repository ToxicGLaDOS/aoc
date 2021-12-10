#!/usr/bin/env elixir

{:ok, content} = File.read("../input/day8.txt")

lines = String.split(content, "\n")
# The last element is an empty line
{_ , lines} = List.pop_at(lines, length(lines) - 1)

defmodule Day8 do
  def find_mapping(list) do
    one = Enum.find(list, fn x -> String.length(x) == 2 end)
    seven = Enum.find(list, fn x -> String.length(x) == 3 end)
    four = Enum.find(list, fn x -> String.length(x) == 4 end)
    eight = Enum.find(list, fn x -> String.length(x) == 7 end)

    # the a segment is just the remainder of 7 - 1
    a = hd(String.graphemes(seven) -- String.graphemes(one))
    nine = Enum.find(list, fn x ->
        # Nine is the only number which has 6 segments and totally overlaps with 4
        String.length(x) == 6 and String.graphemes(four) -- String.graphemes(x) == []
      end
    )

    # the e segment is just the remainder of 8 - 9
    e = hd(String.graphemes(eight) -- String.graphemes(nine))

    # Two is the only number with 5 segments and uses the e segment
    two = Enum.find(list, fn x ->
        String.length(x) == 5 and String.contains?(x, e)
      end
    )

    three = Enum.find(list, fn x ->
        # Three is the only number with 5 segments and differs from two in 1 places
        String.length(x) == 5 and length(String.graphemes(two) -- String.graphemes(x)) == 1
      end
    )
    
    five = Enum.find(list, fn x ->
        # Five is the only number left with 5 segments
        String.length(x) == 5 and x != two and x != three
      end
    )

    six = Enum.find(list, fn x ->
        # five - six and five - nine yields no segments so if we exclude nine all that's left is six
        String.length(x) == 6 and x != nine and String.graphemes(five) -- String.graphemes(x) == []
      end
    )

    zero = Enum.find(list, fn x ->
        # Zero is the only number left with 6 segments
        String.length(x) == 6 and x != six and x != nine
      end
    )

    d = hd(String.graphemes(eight) -- String.graphemes(zero))
    c = hd(String.graphemes(eight) -- String.graphemes(six))
    b = hd(String.graphemes(five)  -- String.graphemes(three))
    f = hd(String.graphemes(three) -- String.graphemes(two))
    g = hd((String.graphemes(three) -- String.graphemes(four)) -- String.graphemes(seven))

    %{
      a => "a",
      b => "b",
      c => "c",
      d => "d",
      e => "e",
      f => "f",
      g => "g"
     }
  end

  def decode(list, mapping, number_mapping) do
    unscrambled_char_list = Enum.map(list, fn x ->
      Enum.map(String.graphemes(x), fn y -> 
          mapping[y]
      end)
    end)

    sorted_strings = Enum.map(unscrambled_char_list, fn x ->
      to_string(Enum.sort(x))
    end)


    {number, _} = Integer.parse( to_string( Enum.map(sorted_strings, fn x ->
      number_mapping[x]
    end)))

    number
  end
end

number_mapping = %{
  "abcefg"  => "0",
  "cf"      => "1",
  "acdeg"   => "2",
  "acdfg"   => "3",
  "bcdf"    => "4",
  "abdfg"   => "5",
  "abdefg"  => "6",
  "acf"     => "7",
  "abcdefg" => "8",
  "abcdfg"  => "9"
}

# Should be 3
#IO.puts(Day8.count_unique(["foo", "bar", "a", "bo", "fjkdlsjfklsdjfklsdjfldks"], 0))
#IO.puts(Day8.total_unique(lines, 0))
output_numbers = Enum.map(lines, fn line ->
  [input, output] = String.split(line, " | ")
  mapping = Day8.find_mapping(String.split(input))
  Day8.decode(String.split(output), mapping, number_mapping)
end
)

IO.puts(Enum.sum(output_numbers))
