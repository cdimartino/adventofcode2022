#!/bin/env ruby

require "debug"
require "ostruct"
require "pp"

class Head
  attr_reader :x, :y
  attr_accessor :tail

  def initialize(x, y)
    @x, @y = x, y
  end

  def move(direction, count)
    case direction
    when "D" then @x -= count
    when "U" then @x += count
    when "L" then @y -= count
    when "R" then @y += count
    end
  end

  def step(direction)
    move(direction, 1)
    tail.step if tail.should_move?
  end

  def to_s
    "<HEAD x: #{x} y: #{y}>"
  end
end

class Tail
  attr_reader :x, :y, :head, :visited
  attr_accessor :tail

  def initialize(head)
    @head, @x, @y = head, head.x, head.y
    @visited = [[x, y]]
  end

  def to_s
    "<TAIL x: #{x} y: #{y}, head: #{head}>"
  end

  ALLOWABLE_DISTANCE = 1
  def should_move?
    (head.x - x).abs > ALLOWABLE_DISTANCE || (head.y - y).abs > ALLOWABLE_DISTANCE
  end

  def step
    if head.x == x
      head.y > y ? @y += 1 : @y -= 1
    elsif head.y == y
      head.x > x ? @x += 1 : @x -= 1
    else
      head.x > x ? @x += 1 : @x -= 1
      head.y > y ? @y += 1 : @y -= 1
    end
    visited << [x, y]
    tail.step if tail&.should_move?
  end
end

head = og_head = Head.new(0, 0)

segments = 1.upto(9).map do
  tail = Tail.new(head)
  head.tail = tail
  head = tail
end

moves = File.readlines("input.txt", chomp: true).map { _1.split(%r{\s+}) }.map { [_1, _2.to_i] }
moves.each do |(direction, count)|
  $stdout.write "... "
  # $stdout.write "CMD: #{direction} #{count} -- "
  1.upto(count) do |step|
    $stdout.write "."
    # puts "##{step} from #{tail}... "
    og_head.step(direction)
    # puts "               to   #{tail}"
  end
  puts
end

debugger

# def print_board(board)
#   board.map do |row|
#     row.join(" ")
#   end
# end
