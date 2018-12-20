re = File.read(ARGV[0]).strip[1...-1]

class Node
  attr_accessor :children
  attr_reader :value

  def initialize(value)
    @value = value
    @children = []
  end

  def maxheight
    return 1 unless children.any?
    1 + children.map(&:maxheight).max
  end

  def to_s
    value + children.map(&:to_s).join
  end
end

def parse(re)
  return [] if re.empty?

  ch = re.shift
  tree = Node.new(ch)
  children = []

  case ch
  when ?N, ?S, ?E, ?W
    tree.children = parse(re)
  when ?(
    children.concat(parse(re))
  when ?)
    return children
  end

  [tree]
end

tree = parse(re.chars).first
puts tree
puts tree.maxheight
