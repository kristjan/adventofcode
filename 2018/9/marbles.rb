players, max = ARGV.to_a.map(&:to_i)

circle = [0]
cur = 0
player = 0
scores = Hash.new { 0 }

def add(a, b, mod)
  (a + b + mod) % mod
end

1.upto(max).each do |i|
  if i % 23 == 0
    scores[player] += i
    remove = add(cur, -7, circle.size)
    scores[player] += circle.delete_at(remove)
    cur = add(remove, 0, circle.size)
  else
    pos = add(cur, 2, circle.size)
    circle.insert(pos, i)
    cur = pos
  end
  player = add(player, 1, players)
end

puts scores.values.max
