input = File.open("input.txt").read.chomp.chars

LENGTH = ARGV[0].to_i
IDX_OFFSET = MIN_IDX = LENGTH - 1

input.each.with_index do |char, idx|
  next unless idx >= MIN_IDX
  range = input[idx - IDX_OFFSET..idx]
  if range.uniq.length == LENGTH
    puts range.uniq.join
    puts idx + 1
    break
  end
end
