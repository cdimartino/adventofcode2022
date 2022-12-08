require "debug"

DEBUG = ENV.fetch("DEBUG", "false") == "true"
def debug(msg)
  puts(msg) if DEBUG
end

module Advent
  class Directory
    attr_reader :name, :entries
    include Comparable

    def initialize(name)
      @name = name
      @entries = []
    end

    def <=>(other) = name <=> other.name

    def is_dir? = true

    def has_dirs? = entries.any?(&:is_dir?)

    def size = entries.sum { |entry| entry.size }

    def to_s = "<Dir #{name} - #{entries.size} items @ #{size} bytes>"
  end

  class File
    attr_reader :name, :size

    def initialize(name, size = 0)
      @name, @size = name, size
    end

    def is_dir? = false

    def to_s = "<File: #{name} (#{size} bytes)>"
  end
end

root = Advent::Directory.new("/")
dirstack = [root]

File.readlines("input.txt", chomp: true).each do |line|
  debug "#{dirstack.map(&:name).join("/")}# INPUT LINE: #{line}"
  if (matches = line.match(/^\$ (?<command>\w+) ?(?<target>\S*)$/)) # Line is a command line
    debug "\tCMD: #{matches[:command]} | TARGET: #{matches[:target]}"

    # CMD: cd
    if matches[:command] == "cd"
      # cd ..
      if matches[:target] == ".."
        debug "\t\tMoving up a level. Before dirstack: #{dirstack.map(&:name)}"
        dirstack.pop
        debug "\t\tMoved up a level. After dirstack: #{dirstack.map(&:name)}"
      # cd /
      elsif matches[:target] == "/"
        debug "\t\tMoving up to root. Before dirstack: #{dirstack.map(&:name)}"
        dirstack.slice!(1..)
        debug "\t\tMoved up to root. After dirstack: #{dirstack.map(&:name)}"
      # cd <dir>
      else
        debug "\t\tMoving down a level. Before dirstack: #{dirstack.map(&:name)}"
        newdir = dirstack.last.entries.find { |stack| stack.name == matches[:target] }
        dirstack << newdir
        debug "\t\tMoved down a level. After dirstack: #{dirstack.map(&:name)}"
      end
    end
  elsif matches = line.match(/^dir (?<dirname>\S+)/) # Line is an output from prior command
    debug "\tAdding directory entry to #{dirstack.last} - DIR: #{matches[:dirname]}"

    dirstack.last.entries << Advent::Directory.new(matches[:dirname])
  elsif matches = line.match(/^(?<size>\d+) (?<filename>\S+)/) # Line is an output from prior command
    debug "\tAdding file entry to #{dirstack.last} - FILE: #{matches[:filename]} - #{matches[:size]}"

    dirstack.last.entries << Advent::File.new(matches[:filename], matches[:size].to_i)
  else
    error "\tWTF! #{line}"
  end
end

def under_100s(dir)
  candidates = dir.entries.select(&:is_dir?).select { |dir| dir.size <= 100_000 }
  candidates + dir.entries.select(&:is_dir?).flat_map { |big_dir| under_100s(big_dir) }.compact
end

targets = under_100s(root)
puts "Part One: `#{targets.sum(&:size)}`"

TOTAL_SPACE = 70_000_000
REQUIRED_SPACE = 30_000_000

CURRENT_SPACE = (TOTAL_SPACE - root.size)
TO_FIND = REQUIRED_SPACE - CURRENT_SPACE

def dir_sizes(root)
  root.entries.select(&:is_dir?).flat_map { |dir| dir_sizes(dir) } +
    [{name: root.name, size: root.size}]
end

puts "Part Two: `#{dir_sizes(root).flatten.sort_by { |rec| rec[:size] }.find { |rec| rec[:size] >= TO_FIND }}`"
