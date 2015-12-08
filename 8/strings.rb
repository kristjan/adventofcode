lines = File.readlines(ARGV[0]).each(&:strip!)

code = lines.map(&:size).inject(:+)
evaled = lines.map { |l| eval(l).size }.inject(:+)
encoded = lines.map(&:inspect).map(&:size).inject(:+)

puts "Code characters: #{code}"
puts "String characters: #{evaled}"
puts "Encoded characters: #{encoded}"

puts "Original Diff: #{code - evaled}"
puts "Encoded Diff: #{encoded - code}"
