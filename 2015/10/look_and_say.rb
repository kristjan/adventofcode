input, iterations = ARGV.to_a
iterations = iterations.to_i

out = input
iterations.times do
  sets = out.chars.slice_when do |before, after|
    before != after
  end
  out = sets.map do |set|
    [set.size, set.first]
  end.flatten.join
end

puts "Result length after #{iterations} iterations: #{out.length}"
