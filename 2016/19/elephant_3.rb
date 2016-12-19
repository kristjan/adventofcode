elf_count = ARGV[0].to_i

elves = Array.new(elf_count) { |i| i + 1}
current = 0

while elves.size > 1
  print "#{elves.size}    \r"
  half = elves.size / 2
  across = (current + half) % elves.size
  #puts "#{elves[current]} Deleting #{elves[across]}"
  elves.delete_at(across)
  current -= 1 if across < current
  current = (current + 1) % elves.size
end

puts elves[current]
