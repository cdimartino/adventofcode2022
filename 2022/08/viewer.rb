#!/bin/env ruby

def debug(msg)
  puts(msg) if ENV.fetch("DEBUG", "false") == "true"
end

class Tree
  attr_reader :height, :x, :y
  attr_accessor :forest

  def inspect
    "<Tree @ #{x}/#{y} #{height}' in forest #{forest.object_id}>"
  end

  def initialize(height, x, y)
    @height, @x, @y = height, x, y
  end

  def visible?(surrounding_trees = [])
    return true if surrounding_trees.empty?
    surrounding_trees.all? { |tree| tree.height < height }
  end

  def to_s
    "<Tree height: #{height} x: #{x} y: #{y} scenic_score: #{scenic_score} (#{view_left} * #{view_up} * #{view_right} * #{view_down})>"
  end

  def scenic_score
    view_left * view_right * view_up * view_down
  end

  def left_trees
    forest.trees[x][0...y].reverse
  end

  def view_left
    return 0 if y == 0
    index = left_trees.find_index { |tree| tree.height >= height }
    index ? index + 1 : y
  end

  def right_trees
    forest.trees[x][y+1..]
  end

  def view_right
    return 0 if y == forest.trees.first.length - 1
    index = right_trees.find_index { |tree| tree.height >= height }
    index ? index + 1 : forest.trees.first.length - y
  end

  def up_trees
    forest.trees[0...x].map { |row| row[y] }.reverse
  end

  def view_up
    return 0 if x == 0
    index = up_trees.find_index { |tree| tree.height >= height }
    index ? index + 1 : x
  end

  def down_trees
    forest.trees[x+1..].map { |row| row[y] }
  end

  def view_down
    return 0 if x == forest.trees.length - 1
    index = down_trees.find_index { |tree| tree.height >= height }
    index ? index + 1 : forest.trees.length - x - 1
  end
end

class Forest
  attr_reader :trees

  def initialize(trees = [])
    @trees = trees
  end

  def visible_count
    visible_trees = 0
    trees.each.with_index do |row, x|
      row.each.with_index do |tree, y|
        visibility = []
        visibility << tree.visible?(trees[0...x].map { |row| row[y] })
        visibility << tree.visible?(trees[x + 1..].map { |row| row[y] })
        visibility << tree.visible?(trees[x][0...y])
        visibility << tree.visible?(trees[x][y + 1..])
        debug("#{tree} visibility: #{visibility.join(", ")}")
        visible_trees += 1 if visibility.any?
      end
    end
    visible_trees
  end

  def self.from_heights(rows)
    trees = rows.map.with_index do |row, x|
      row.chars.map.with_index do |height, y|
        Tree.new(height, x, y)
      end
    end

    new(trees).tap do |forest|
      forest.trees.each { |row| row.each { |tree| tree.forest = forest } }
    end
  end
end

matrix = File.readlines("input.txt", chomp: true)
require "debug"
# debugger

forest = Forest.from_heights(matrix)
puts "Part One: #{forest.visible_count} - #{forest.visible_count == 1812 ? "🍺" : "💩"}"

require "pp"
# debugger
forest.trees.flat_map { |row| row.map { |tree| tree } }.sort_by { |tree| tree.scenic_score }.each { puts _1 }

