players, max = ARGV.to_a.map(&:to_i)

class Node
  attr_accessor :value, :nxt, :prv

  def initialize(value)
    @value = value
    @nxt = nil
    @prv = nil
  end
end

cur = Node.new(0)
cur.nxt = cur.prv = cur

player = 0
scores = Hash.new { 0 }

1.upto(max).each do |i|
  if i % 23 == 0
    scores[player] += i
    7.times { cur = cur.prv }
    scores[player] += cur.value
    cur.prv.nxt = cur.nxt
    cur.nxt.prv = cur.prv
    cur = cur.nxt
  else
    cur = cur.nxt
    fresh = Node.new(i)
    fresh.nxt = cur.nxt
    fresh.prv = cur
    cur.nxt.prv = fresh
    cur.nxt = fresh
    cur = fresh
  end

  player = (player + 1) % players
end

puts scores.values.max
