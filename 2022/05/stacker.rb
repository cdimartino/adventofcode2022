#!/bin/enb ruby

require "debug"

DEBUG = ENV.fetch("DEBUG", "false") == "true"

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

  def debug msg
    warn msg if DEBUG
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

def debug
  if DEBUG
    yield
  end
end

SPEED = ENV.fetch("SPEED", 0.2).to_f

# Part 1
stacker = Stacker.from_input(stack_info.reverse)
instructions.each do |(quantity, from, to)|
  debug do
    pp stacker.stacks.map(&:join)
  end
  stacker.move(quantity, from, to, move_items_separately: true)
  debug do
    pp stacker.stacks.map(&:join)
    sleep(SPEED)
    puts "Continue... "
    gets
  end
end
part_1 = stacker.stacks.map(&:last).join

# Part 2
stacker = Stacker.from_input(stack_info.reverse)
instructions.each do |(quantity, from, to)|
  stacker.move(quantity, from, to, move_items_separately: false)
  debug do
    # pp stacker.stacks.map(&:join)
    sleep(SPEED)
  end
end

part_2 = stacker.stacks.map(&:last).join

puts "Part 1 answer: #{part_1}"
puts "Part 2 answer: #{part_2}"

# puts "Ran #{instructions.size} moves, affecting #{instructions.map { _1[0] }.sum} boxes"
