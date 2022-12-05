#!/bin/enb ruby

require "debug"

class Stacker
  attr_reader :stacks

  def initialize(stacks)
    @stacks = stacks
  end

  def self.from_input(lines)
    column_idxs = [1, 5, 9, 13, 17, 21, 25, 29, 33]

    [].then do |stacks|
      lines.each do |line|
        column_idxs.each_with_index do |line_idx, stack_idx|
          stacks[stack_idx] ||= []

          item = line[line_idx]&.strip
          stacks[stack_idx] << item unless item.nil? || item.empty?
        end
      end

      new(stacks)
    end
  end

  def move(count, from, to, move_items_separately: true)
    debug "Moving #{count} #{from + 1}<#{stacks[from].join}> to #{to + 1}<#{stacks[to].join}>"

    stack_to_move = if move_items_separately
      stacks[from].pop(count).reverse
    else
      stacks[from].pop(count)
    end
    stacks[to] += stack_to_move

    debug "Moved #{count} #{from + 1}<#{stacks[from].join}> to #{to + 1}<#{stacks[to].join}>"
  end

  private

  DEBUG = true
  def debug msg
    puts msg if DEBUG
  end
end

# Roughly parse the input
input = File.open("input.txt").readlines.map(&:chomp)
stack_info = input[0..7]
moves = input[10..]

# Parse the _moves_ from the file using a Regex. Instruct the Stacker on actions to take.
RE = /move (?<quantity>\d+) from (?<from>\d+) to (?<to>\d+)/o

instructions = moves.map do |instruction|
  move = RE.match(instruction).named_captures
  [
    move["quantity"].to_i,
    move["from"].to_i - 1, # 0 indexed
    move["to"].to_i - 1 # 0 indexed
  ]
end

# Create the Stacker using the input lines (not including the header)

# Part 1
stacker = Stacker.from_input(stack_info.reverse)
instructions.each do |(quantity, from, to)|
  stacker.move(quantity, from, to, move_items_separately: true)
end
puts "Part 1 answer: #{stacker.stacks.map(&:last).join}"

# Part 2
stacker = Stacker.from_input(stack_info.reverse)
instructions.each do |(quantity, from, to)|
  stacker.move(quantity, from, to, move_items_separately: false)
end
puts "Part 2 answer: #{stacker.stacks.map(&:last).join}"
