def debug(msg)
  puts msg if ENV.fetch("DEBUG", "false") == "true"
end

def info(msg)
  puts msg if ENV.fetch("INFO", "false") == "true"
end

def input_lines
  File.readlines("input.txt", chomp: true)
end
