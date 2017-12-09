data = File.readlines(ARGV[0])

lookup = {}

class Node
  attr_accessor :name, :children, :parent, :weight

  def initialize(name)
    @name = name
    @weight = weight
    @children = []
  end

  def total_weight
    (children.map(&:total_weight).inject(:+) || 0) + weight
  end

  def to_s
    "#{name} #{weight}"
  end
end

data.each do |row|
  parent, children = row.split('->')
  parent = parent.strip

  children ||= ''
  children = children.split(',').map(&:strip)

  name, weight = parent.split(' ')
  weight = weight.delete('()').to_i

  lookup[name] ||= Node.new(name)
  lookup[name].weight = weight

  children.each { |child| lookup[child] ||= Node.new(child) }

  lookup[name].children = children.map{|child| lookup[child]}
  lookup[name].children.each {|child| child.parent = lookup[name]}
end

root = lookup.values.detect{|n| n.parent.nil?}
puts root.name

stack = [root]
while stack.any?
  cur = stack.shift
  child_weights = cur.children.map(&:total_weight)
  if child_weights.uniq.size > 1
    puts child_weights.zip(cur.children.map(&:weight)).inspect
  end
  stack.concat(cur.children)
end
