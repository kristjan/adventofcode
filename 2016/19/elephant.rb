elf_count = ARGV[0].to_i

elves = Array.new(elf_count) { 1 }
current = 0

while true
  #puts elves.inspect
  if elves[current] == 0
    #puts "Skipping #{current}"
    current = (current + 1) % elf_count
    next
  end
  neighbor = (current + 1) % elf_count
  while elves[neighbor] == 0
    neighbor = (neighbor + 1) % elf_count
  end
  #puts "#{current} stealing from #{neighbor}"
  elves[current] += elves[neighbor]
  elves[neighbor] = 0
  if elves[current] == elf_count
    puts "#{current} / #{current + 1} has everything"
    exit
  end
  current = (neighbor + 1) % elf_count
end
