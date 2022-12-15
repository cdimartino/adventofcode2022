require_relative "../helpers"
require "memery"
require "set"

class Climb
  attr_reader :depth, :map, :successful_depths

  def initialize(map)
    @map = map
    @successful_depths = []
    @count = 0
  end

  def attempt
    climb(map.start)
  end

  DEAD_ENDS = Set.new

  def climb(location, prior_path = Set.new)
    @count += 1
    path = Set.new(prior_path.to_a + [location])

    map.test_location = location

    $stderr.write "#{@count}\r"
    info map.to_s(path)
    debug "@#{location}:\n\n"

    if map.finish.location?(location.x, location.y)
      @successful_depths << path.to_a
      debug "FOUND THE ENDING"
    else
      unvisited = Set.new(map.possible_moves_from(location)) - path - DEAD_ENDS
      debug "\tNot the end - exploring possible unvisited locations: #{unvisited.join(", ")}"

      if unvisited.empty?
        DEAD_ENDS << location
        return
      end

      followed_path = Set.new
      unvisited.sort_by { |loc| (loc.x - map.finish.x).abs * (loc.y - map.finish.y).abs }.each do |next_location|
        debug "\tclimbing to #{next_location} from #{path.to_a.join(",")}"
        new_path = climb(next_location, path + followed_path)
        followed_path += new_path if new_path
      end
    end
    path
  end
end

class Map
  include Memery
  attr_reader :locations
  attr_accessor :start, :finish, :test_location

  def initialize
    @locations = []
  end

  def to_s(path = nil)
    map = @locations.map.with_index do |row, x|
      row.map.with_index do |location, y|
        if start.location?(x, y)
          "S"
        elsif finish.location?(x, y)
          "E"
        elsif test_location&.location?(x, y)
          "*"
        elsif path && path.include?(location)
          "#"
        else
          location.height
        end
      end.join
    end.join("\n")

    <<~MAP
      #####
        start: #{start}
        finish: #{finish}
        @ #{test_location}
      #####

      #{map}

    MAP
  end

  def <<(location)
    @locations[location.x] ||= []
    @locations[location.x][location.y] = location
  end

  memoize def surrounding_locations(location)
    x, y = location.x, location.y

    left = locations[x][y - 1] if y > 0
    right = locations[x][y + 1] if y < locations[x].length - 1
    up = locations[x - 1][y] if x > 0
    down = locations[x + 1][y] if x < locations.length - 1

    [left, up, right, down].compact.tap do |surrounding|
      debug "#{location} surrounding: #{surrounding.join(" | ")}"
    end
  end

  memoize def possible_moves_from(location)
    surrounding_locations(location).filter do |new_location|
      location.can_move_to?(new_location)
    end.to_set
  end
end

class Location
  include Memery
  attr_reader :x, :y, :height

  def initialize(x, y, height)
    @x, @y, @height = x, y, height
  end

  memoize def can_move_to?(location)
    height >= location.height || height.succ == location.height
  end

  memoize def ==(other)
    location?(other.x, other.y)
  end

  memoize def location?(x, y)
    @x == x && @y == y
  end

  memoize def location
    [x, y]
  end

  memoize def to_s
    "<#{x}/#{y} - #{height}>"
  end
end

map = Map.new
# INPUT = "small_input.txt"
INPUT = "input.txt"
input_lines(INPUT).each.with_index do |line, x|
  line.each_char.with_index do |char, y|
    height = if char == "S"
      "a"
    elsif char == "E"
      "z"
    else
      char
    end

    map << location = Location.new(x, y, height)

    if char == "S"
      map.start = location
    elsif char == "E"
      map.finish = location
    end
  end
end

climber = Climb.new(map)
climber.attempt

found_paths = climber.successful_depths
tally = found_paths.map { _1.length - 1 }.tally
puts <<~PATH_INFO
  Found #{found_paths.length} possible paths:
  #{tally.sort.to_h}
PATH_INFO
