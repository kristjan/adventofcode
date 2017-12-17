input, loops = ARGV.to_a.map(&:to_i)

class Node
  attr_accessor :value, :next

  def initialize(value)
    @value = value
  end

  def insert_after(neighbor)
    neighbor.next = self.next
    @next = neighbor
  end
end

def find(list, value)
  list = list.next until list.value == value
  list
end

head = cur = Node.new(0)
cur.next = cur
last = nil

1.upto(loops) do |i|
  puts i if i % 10000 == 0
  input.times { cur = cur.next }
  insert = Node.new(i)
  cur.insert_after(insert)
  cur = insert
  if last != head.next.value
    last = head.next.value
    puts "\t#{last}\t-\t-\t-"
  end
end

puts
puts find(cur, 2017).next.value
puts find(cur, 0).next.value
