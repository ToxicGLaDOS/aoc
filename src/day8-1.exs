#!/usr/bin/env elixir

# This map maps the unique counts to their given number on the 7-segment display
# A number with 3 segments is a 7, a number with 4 segements is a 4 and so on...
#countMap = %{3 => 7, 4 => 4, 2 => 1, 7 => 8 }

{:ok, content} = File.read("../input/day8.txt")

lines = String.split(content, "\n")
# The last element is an empty line
{_ , lines} = List.pop_at(lines, length(lines) - 1)

defmodule Day8 do

  # Counts the number of strings in the list that have
  # either 2, 3, 4, or 7 characters where the list is words
  def count_unique([head | tail], accumulator) do
    case String.length(head) do
      x when x in [2, 3, 4, 7] ->
        count_unique(tail, accumulator + 1)
      _ ->
        count_unique(tail, accumulator)
    end
  end

  def count_unique([], accumulator) do
    accumulator
  end

  # Counts the number of strings in the list that have
  # either 2, 3, 4, or 7 characters where the list is lines
  def total_unique([head | tail], accumulator) do
    [input, output] = String.split(head, " | ")

    _input = String.split(input)
    output = String.split(output)

    total_unique(tail, accumulator + Day8.count_unique(output, 0))
  end

  def total_unique([], accumulator) do
    accumulator
  end
end

# Should be 3
#IO.puts(Day8.count_unique(["foo", "bar", "a", "bo", "fjkdlsjfklsdjfklsdjfldks"], 0))
IO.puts(Day8.total_unique(lines, 0))

