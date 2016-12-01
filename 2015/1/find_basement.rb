str = $stdin.read.strip

floor = 0
str.chars.each.with_index(1) do |c, i|
  floor += (c == '(' ? 1 : -1)
  puts i and break if floor == -1
end
