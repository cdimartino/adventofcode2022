require "debug"

DEBUG = ENV.fetch("DEBUG", "false") == "true"
def debug(msg)
  puts(msg) if DEBUG
end

module Advent
  class Directory
    include Comparable
    attr_reader :name, :parent, :entries

    def initialize(name, parent = nil)
      @name, @parent = name, parent
      @entries = {}
    end

    def entry(entry)
      entries[entry.name] ||= entry
    end

    def path = [parent&.path, name].join("/")

    def <=>(other) = name <=> other.name

    def is_dir? = true

    def has_dirs? = entries.any?(&:is_dir?)

    def size = entries.values.sum { |entry| entry.size }

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

root = Advent::Directory.new("")
cwd = root

File.readlines("input.txt", chomp: true).each do |line|
  debug "#{cwd.path}# INPUT LINE: #{line}"

  if (matches = line.match(/^\$ (?<command>\w+) ?(?<target>\S*)$/)) # Line is a command line
    debug "\tCMD: #{matches[:command]} | TARGET: #{matches[:target]}"

    # CMD: cd
    if matches[:command] == "cd"
      prior_cwd = cwd
      cwd = if matches[:target] == ".."
        cwd&.parent || root
      elsif matches[:target] == "/"
        root
      else
        cwd.entries[matches[:target]]
      end
      debug "Changed CWD from #{prior_cwd} to #{cwd}"
    end
  elsif matches = line.match(/^dir (?<dirname>\S+)/) # Line is an output from prior command
    debug "\tAdding directory entry to #{cwd} - DIR: #{matches[:dirname]}"
    cwd.entry Advent::Directory.new(matches[:dirname], cwd)
  elsif matches = line.match(/^(?<size>\d+) (?<filename>\S+)/) # Line is an output from prior command
    debug "\tAdding file entry to #{cwd} - FILE: #{matches[:filename]} - #{matches[:size]}"
    cwd.entry Advent::File.new(matches[:filename], matches[:size].to_i)
  else
    error "\tWTF! #{line}"
  end
end

def under_100s(dir)
  candidates = dir.entries.values.select(&:is_dir?).select { |dir| dir.size <= 100_000 }
  candidates + dir.entries.values.select(&:is_dir?).flat_map { |big_dir| under_100s(big_dir) }.compact
end

targets = under_100s(root)
total_size = targets.sum(&:size)
puts "Part One: `#{total_size}` - #{total_size == 919137 ? "🍺" : "💩"}"

TOTAL_SPACE = 70_000_000
REQUIRED_SPACE = 30_000_000

CURRENT_SPACE = (TOTAL_SPACE - root.size)
TO_FIND = REQUIRED_SPACE - CURRENT_SPACE

def dir_sizes(root)
  root.entries.values.select(&:is_dir?).flat_map { |dir| dir_sizes(dir) } +
    [{name: root.name, size: root.size}]
end

to_delete = dir_sizes(root).flatten.sort_by { |rec| rec[:size] }.find { |rec| rec[:size] >= TO_FIND }
puts "Part Two: `#{to_delete}` - #{to_delete[:size] == 2877389 ? "🍺" : "💩"}"
