require 'set'

banks = File.read(ARGV[0]).split(/\s+/).map(&:to_i)

def run(banks)
  seen = Set.new
  cycles = 0
  while !seen.include?(banks)
    seen << banks
    max = banks.max
    i = banks.index(max)
    blocks = banks[i]
    banks[i] = 0
    blocks.times do
      i += 1
      i = 0 if i >= banks.size
      banks[i] += 1
    end
    cycles += 1
  end
  cycles
end

puts "Time to cycle"
puts run(banks)
puts
puts "Cycle length"
puts run(banks)
