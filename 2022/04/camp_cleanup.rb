#!/bin/env ruby

require "set"

class ElfPair
  attr_reader :range_a, :range_b

  def initialize(spread_a, spread_b)
    @range_a, @range_b = to_set(spread_a), to_set(spread_b)
  end

  def is_wholly_overlapping?
    range_a.superset?(range_b) || range_a.subset?(range_b)
  end

  def is_intersecting?
    range_a.intersect?(range_b)
  end

  def to_s
    <<~HO
      Elf A: #{range_a.to_a.join(", ")}
      Elf B: #{range_b.to_a.join(", ")}
    HO
  end

  private

  def to_set(spread)
    spread.split("-").map(&:to_i).then do |(start, finish)|
      Set.new(start.upto(finish))
    end
  end
end

DEBUG = false

def debug(msg)
  puts msg if DEBUG
end

input = File.readlines("input.txt")

overlapping = input.map do |line|
  range_a, range_b = line.split(",")
  ElfPair.new(range_a, range_b).then do |pair|
    debug "ElfPair:\n#{pair} - wholly overlapping? #{pair.is_wholly_overlapping?}"
    {
      wholly_overlapping: pair.is_wholly_overlapping?,
      any_overlapping: pair.is_intersecting?
    }
  end
end

puts <<~TALLY
  Wholly overlapping tally: #{overlapping.map { _1[:wholly_overlapping] }.tally}
  Any overlapping tally: #{overlapping.map { _1[:any_overlapping] }.tally}
TALLY
