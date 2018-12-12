input = File.readlines(ARGV[0]).map(&:strip)
generations = ARGV[1].to_i

initial_data = input[0]

plants = Hash.new { ?. }

initial_data.chars.each.with_index do |plant, i|
  plants[i] = plant
end

rules = {}
input[2..-1].each do |rule|
  state, result = rule.split(' => ')
  rules[state] = result
end

def tick(plants, rules)
  left, right = plants.keys.minmax
  new_plants = Hash.new { ?. }
  ((left-2)..(right+2)).each do |pos|
    key = ((pos-2)..(pos+2)).map{ |p| plants[p] }.join
    #puts [pos, key, rules[key]].inspect
    new_plants[pos] = rules[key]
  end
  return new_plants
end

def prune!(plants)
  left, right = plants.keys.minmax
  while plants[left] == ?.
    plants.delete(left)
    left += 1
  end
  while plants[right] == ?.
    plants.delete(right)
    right -= 1
  end
end

def admire(plants)
  puts plants.to_a.sort_by(&:first).map(&:last).join
end

def total(plants)
  sum = 0
  plants.each do |pos, plant|
    sum += pos if plant == ?#
  end
  sum
end

#admire(plants)
last = 0
generations.times do |i|
  plants = tick(plants, rules)
  prune!(plants)
  t = total(plants)
  puts [i, t, t - last].inspect
  last = t
  #admire(plants)
end

puts total(plants)

# At generation 100 (given this input), the plants total 6175 poits and
# stabilize to producing 50 more points per generation, so the general solution
# is
#     6175 + (G - 100) * 50
