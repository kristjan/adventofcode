input = ARGV[0]

recipes = "37"
elves = [0, 1]

def add(a, b, mod)
  (a + b) % mod
end

last_checked = 0
while true
  1000.times do
    total = elves.map{|pos| recipes[pos]}.map(&:to_i).inject(:+)
    digits = total.to_s
    recipes << digits
    elves.each.with_index do |pos, i|
      elves[i] = add(pos, 1 + recipes[pos].to_i, recipes.size)
    end
  end
  pos = recipes.index(input, last_checked)
  break if pos
  last_checked = recipes.size - 10
end

puts pos
