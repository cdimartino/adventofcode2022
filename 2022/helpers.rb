require "debug"

def debug(msg)
  puts msg if ENV.fetch("DEBUG", "false") == "true"
end

def info(msg)
  puts msg if ENV.fetch("INFO", "false") == "true"
end

def input_lines(file = "input.txt")
  File.readlines(file, chomp: true)
end
