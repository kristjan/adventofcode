require 'set'

changes = File.readlines(ARGV[0]).map { |line| Integer(line) }

frequency = 0
changes.each {|c| frequency += c}
puts frequency

seen = Set.new
frequency = 0
changes.cycle.each do |c|
  frequency += c
  if seen.include?(frequency)
    puts frequency
    break
  end
  seen << frequency
end
