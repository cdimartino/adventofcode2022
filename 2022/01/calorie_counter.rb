#!/bin/ruby

# From https://adventofcode.com/2022/day/1

DEBUG = false

def debug msg
  puts msg if DEBUG
end

@elves = [0]

$stdin.readlines.each do |line|
  if %r{\d+}o.match?(line)
    debug "Found #{line.to_i} calories - adding to elf #{@elves.length - 1}"
    @elves[-1] += line.to_i
  else
    debug "Found blank line - new elf!"
    @elves << 0
  end
end

top_3 = @elves.map.with_index {
  {elf: _2, calories: _1}
}.sort_by { |elf|
  elf[:calories]
}.last(3)

pp top_3
pp top_3.sum { _1[:calories] }
