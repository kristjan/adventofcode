elf_count = ARGV[0].to_i

elves = Array.new(elf_count) { |i| i + 1}

while elves.size > 1
  print "#{elves.size}    \r"
  across = elves.size / 2
  #puts "#{elves[0]} Deleting #{elves[across]}"
  elves.delete_at(across)
  elves.rotate!
end

puts elves.inspect
puts elves[0]
