data = File.read(ARGV[0]).split("\n")

actual = ''

data.first.length.times do |index|
  chars = data.map{|d| d[index]}
  ch = chars.group_by(&:to_s).map{|c, g| [c, g.size]}.sort_by(&:last).first.first
  actual << ch
end

puts actual
