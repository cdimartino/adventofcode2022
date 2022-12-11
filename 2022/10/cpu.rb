input_file = "input.txt"
# input_file = "medium_input.txt"

class Computer
  attr_reader :cycle
  attr_accessor :instructions

  def initialize
    reset
  end

  def reset
    @cycle, @instructions = 1, [1]
  end

  def perform(instruction, operand)
    return unless instruction
    self.instructions +=
      case instruction
      when "noop" # noop
        [0]
      when "addx"
        [0, operand]
      end
  end

  def busy?
    instructions.length >= cycle
  end

  def register
    instructions[0..cycle - 1].sum { _1 }
  end

  def signal_strength
    register * cycle
  end

  def tick
    @cycle += 1
  end

  def to_s
    "<Computer cycle: #{cycle} register: #{register} signal: #{signal_strength} instr: #{instructions.join(",")}>"
  end
end

class Crt
  attr_accessor :sprite, :pixels, :position

  def initialize
    @position = 0
    @sprite = [0, 1, 2]
    @pixels = []
  end

  def move_sprite(x)
    multiplier = @position / 40
    @sprite = ((40 * multiplier) + x).upto((40 * multiplier) + x + 2).to_a
  end

  def pixel
    @sprite.include?(position + 1) ? "#" : "."
  end

  def draw
    @pixels << pixel
    @position += 1
  end

  def inspect
    "<CRT pos: #{position} spr: #{sprite.join} pixel: #{pixel}>"
  end

  COLS = 40

  def to_s
    @pixels.each_slice(COLS) do |row|
      puts row.join
    end
  end
end

input = File.readlines(input_file, chomp: true).map { _1.split(/\s+/) }

cpu = Computer.new
notable_signals = []

0.upto(221).each do |cycle|
  # puts "Before: #{cpu}"
  cmd, operand = input.shift
  # puts "# #{cmd} #{operand}\n\n"
  cpu.perform(cmd, operand.to_i)
  cpu.tick
  # puts "after: #{cpu}\n\n"
  if [20, 60, 100, 140, 180, 220].include?(cpu.cycle)
    notable_signals << cpu.signal_strength
  end
end

puts "Part 1: #{notable_signals.sum} - #{notable_signals.sum == 13740 ? "🍺" : "💩"}"

input = File.readlines(input_file, chomp: true).map { _1.split(/\s+/) }
cpu.reset
crt = Crt.new

1.upto(240).each do |cycle|
  # puts cpu
  cmd, operand = input.shift
  crt.draw
  cpu.perform(cmd, operand.to_i) if cmd
  cpu.tick
  crt.move_sprite(cpu.register)
  # puts cpu
  # puts crt.inspect
end
$stdout.write(crt.to_s)
