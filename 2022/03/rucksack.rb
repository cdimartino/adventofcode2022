# From https://adventofcode.com/2022/day/3

# --- Day 3: Rucksack Reorganization ---
# One Elf has the important job of loading all of the rucksacks with supplies for the jungle journey. Unfortunately, that Elf didn't quite follow the packing instructions, and so a few items now need to be rearranged.
#
# Each rucksack has two large compartments. All items of a given type are meant to go into exactly one of the two compartments. The Elf that did the packing failed to follow this rule for exactly one item type per rucksack.
#
# The Elves have made a list of all of the items currently in each rucksack (your puzzle input), but they need your help finding the errors. Every item type is identified by a single lowercase or uppercase letter (that is, a and A refer to different types of items).
#
# The list of items for each rucksack is given as characters all on a single line. A given rucksack always has the same number of items in each of its two compartments, so the first half of the characters represent items in the first compartment, while the second half of the characters represent items in the second compartment.
#
# For example, suppose you have the following list of contents from six rucksacks:
#
# vJrwpWtwJgWrhcsFMMfFFhFp
# jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
# PmmdzqPrVvPwwTWBwg
# wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
# ttgJtRGJQctTZtZT
# CrZsJsPPZsGzwwsLwLmpwMDw
# The first rucksack contains the items vJrwpWtwJgWrhcsFMMfFFhFp, which means its first compartment contains the items vJrwpWtwJgWr, while the second compartment contains the items hcsFMMfFFhFp. The only item type that appears in both compartments is lowercase p.
# The second rucksack's compartments contain jqHRNqRjqzjGDLGL and rsFMfFZSrLrFZsSL. The only item type that appears in both compartments is uppercase L.
# The third rucksack's compartments contain PmmdzqPrV and vPwwTWBwg; the only common item type is uppercase P.
# The fourth rucksack's compartments only share item type v.
# The fifth rucksack's compartments only share item type t.
# The sixth rucksack's compartments only share item type s.
# To help prioritize item rearrangement, every item type can be converted to a priority:
#
# Lowercase item types a through z have priorities 1 through 26.
# Uppercase item types A through Z have priorities 27 through 52.
# In the above example, the priority of the item type that appears in both compartments of each rucksack is 16 (p), 38 (L), 42 (P), 22 (v), 20 (t), and 19 (s); the sum of these is 157.
#
# Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?

class CommonThingFinder
  def initialize(list1, list2)
    @list1, @list2 = list1, list2
  end

  def common_element
    (@list1 & @list2).first
  end
end

class Priority
  def initialize(letter)
    @letter = letter
  end

  PRIORITIES = ([nil] + "a".upto("z").to_a + "A".upto("Z").to_a).map.with_index { |v, i| [v, i] }.to_h

  def to_i
    PRIORITIES[@letter]
  end
end

input = File.readlines("input.txt")

rucksacks = input.map do |line|
  len = line.length
  [
    line[...(len / 2)].chars,
    line.chomp[(len / 2)..].chars
  ]
end

priorities_commons = rucksacks.map.with_index do |(compartment_a, compartment_b), i|
  puts "Compartment A: #{compartment_a}"
  puts "Compartment B: #{compartment_b}"

  common_element = CommonThingFinder.new(compartment_a, compartment_b).common_element
  priority = Priority.new(common_element).to_i
  puts "Common element: #{common_element} - priority #{priority}"
  priority
end

puts priorities_commons.sum
