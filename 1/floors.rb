str = $stdin.read.strip

puts str.delete(')').length - str.delete('(').length
