input = File.open("input.txt").read.chomp.chars

LENGTH = ARGV[0].to_i
IDX_OFFSET = MIN_IDX = LENGTH - 1

input.each.with_index do |char, idx|
  next unless idx >= MIN_IDX
  range = input[idx - IDX_OFFSET..idx]
  $stdout.write range.join
  if range.uniq.length == LENGTH
    puts "⭐ #{idx + 1}"
    # break
  else
    puts "👎"
  end
end
