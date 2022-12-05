input = File.open("input.txt").read.chomp.chars

CONS = ARGV[0].to_i

input.each.with_index do |char, idx|
  next unless idx > CONS
  range = input[idx - CONS..idx]
  if range.uniq.length == CONS + 1
    puts range.uniq.join
    puts idx + 1
    break
  end
end
