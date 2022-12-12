require_relative "../helpers"
require "prime"

class Monkey
  attr_accessor :item, :items, :items_inspected, :operation, :comparitor, :if_true, :if_false, :name, :divisor

  def initialize(name)
    @name = name
    @items_inspected = 0
  end

  def inspect_items(monkeys)
    debug name
    until items.empty?
      inspect_item(items.shift, monkeys)
    end
  end

  WORRY_DIVISOR = 9699690
  def inspect_item(item, monkeys)
    debug("\t#{name}(div #{divisor}) inspects an item with a worry level of #{item}.")

    worry_level = operation.call(item)
    debug("\t\tWorry level is permuted from #{item} to #{worry_level}.")

    # debug("Performing modulo of #{worry_level} % #{divisor}")
    # unbroken_worry_level = (worry_level / divisor) + (worry_level % divisor)
    unbroken_worry_level = worry_level % monkeys.map(&:divisor).reduce(&:*)
    debug("\t\tIt's not broken! New worry level = #{unbroken_worry_level}.")
    next_monkey = comparitor.call(unbroken_worry_level)
    debug("\t\tPerform comparison - next monkey #{next_monkey}")
    monkeys[next_monkey].items << unbroken_worry_level
    debug("\t\tItem with worry level #{unbroken_worry_level} is thrown to monkey #{next_monkey}.")
    self.items_inspected += 1
  end

  def to_s
    <<~MONKEY
      <Monkey #{name}
        divisor: #{divisor}
        if_true: #{if_true}
        if_false: #{if_false}
        items: #{items.join(",")}
        items_inspected: #{items_inspected}
    MONKEY
  end
end

class Round
  def initialize(monkeys)
    @monkeys = monkeys
  end

  def perform
    @monkeys.each { |monkey| monkey.inspect_items(@monkeys) }
  end
end
## Load monkeys

monkeys = []
input_lines.each do |line|
  monkey = monkeys.last
  if (matches = %r{^(Monkey \d+):}.match(line))
    monkeys << Monkey.new(matches[1])
  elsif (matches = %r{\s+Starting items: ([\d+,\s]+)}.match(line))
    monkey.items = matches[1].split(", ").map { |item| item.to_i }
  elsif (matches = %r{\s+Operation: ([\w\s=+\-*/]+)}.match(line))
    operation = matches[1]
    if (matches = %r{new = old ([+\-*/]) (\w+)}.match(operation))
      operator, operand = matches[1], matches[2]
      monkey.operation = ->(item) {
        item.send(operator, (operand == "old") ? item : operand.to_i)
      }
    end
  elsif (matches = %r{\s+Test: ([\w\s]+)}.match(line))
    matches[1].then do |test|
      if (matches = %r{divisible by (\d+)}.match(test))
        monkey.divisor = modulus = matches[1].to_i
        monkey.comparitor = ->(item) {
          (item % modulus == 0) ? monkey.if_true : monkey.if_false
        }
      end
    end
  elsif (matches = %r{\s+If true: throw to monkey (\d+)}.match(line))
    monkey.if_true = matches[1].to_i
  elsif (matches = %r{\s+If false: throw to monkey (\d+)}.match(line))
    monkey.if_false = matches[1].to_i
  else
    info monkey
  end
end

1.upto(ARGV[0].to_i).each do |round|
  info "Round #{round}"
  Round.new(monkeys).perform
  info monkeys.each(&:to_s).join("\n")
end

monkey_business = monkeys.sort_by { |monkey|
  -monkey.items_inspected
}.take(2).inject(1) { |acc, monkey| acc * monkey.items_inspected }

puts "Part one: #{monkey_business} == #{monkey_business == 66124 ? "🍺" : "💩"}"
