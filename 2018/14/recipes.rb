init = ARGV[0].to_i

recipes = "37"
elves = [0, 1]

def add(a, b, mod)
  (a + b) % mod
end

(init - 2 + 10).times do
  total = elves.map{|pos| recipes[pos].to_i}.inject(:+)
  digits = total.to_s
  recipes << digits
  elves.each.with_index do |pos, i|
    elves[i] = add(pos, 1 + recipes[pos].to_i, recipes.size)
  end
end

puts recipes[(init)...(init + 10)]
