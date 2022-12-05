#!/bin/enb ruby

class Stacker
  attr_reader :stacks

  def initialize(stacks)
    @stacks = stacks
  end

  def move(count, from, to, reverse: true)
    debug "moving #{count} from #{from} <#{stacks[from - 1]}> to #{to} <#{stacks[to - 1]}>"
    move_stack = reverse ? stacks[from - 1].pop(count).reverse : stacks[from - 1].pop(count)
    stacks[to - 1] += move_stack
    debug "moved #{count} from #{from} <#{stacks[from - 1]}> to #{to} <#{stacks[to - 1]}>"
  end

  private

  DEBUG = true
  def debug msg
    puts msg if DEBUG
  end
end

stacks = [
  %w[Q W P S Z R H D],
  %w[V B R W Q H F],
  %w[C V S H],
  %w[H F G],
  %w[P G J B Z],
  %w[Q T J H W F L],
  %w[Z T W D L V J N],
  %w[D T Z C J G H F],
  %w[W P V M B H]
]

input = File.open("input.txt").readlines.map(&:chomp)
moves = input[10..]

stacker = Stacker.new(stacks)

RE = /move (?<quantity>\d+) from (?<from>\d+) to (?<to>\d+)/o

moves.each do |instruction|
  move = RE.match(instruction).named_captures
  quantity, from, to = move["quantity"].to_i, move["from"].to_i, move["to"].to_i
  stacker.move(quantity, from, to, reverse: false)
end

puts stacker.stacks.map(&:last).join
