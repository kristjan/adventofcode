iterations, a_seed, a_mod, b_seed, b_mod = ARGV.to_a.map(&:to_i)

class Generator
  MOD = 2147483647

  attr_accessor :seed, :factor, :multiple

  def initialize(seed, factor, multiple)
    @seed = seed
    @factor = factor
    @multiple = multiple
  end

  def out
    loop do
      n = seed * factor
      _, mod = n.divmod(MOD)
      @seed = mod
      break if seed % multiple == 0
    end
    seed
  end
end

gen_a = Generator.new(a_seed, 16807, a_mod)
gen_b = Generator.new(b_seed, 48271, b_mod)

count = 0
MASK = 0xffff

iterations.times do |i|
  a = gen_a.out
  b = gen_b.out
  #puts [a, b].map { |n| n.to_s(2).rjust(16, '0')[16..-1] }
  mask_a = a & MASK
  mask_b = b & MASK
  #puts [mask_a, mask_b].inspect
  if mask_a == mask_b
   count += 1
   puts "Found #{count} of #{i}"
  end
end

puts count
