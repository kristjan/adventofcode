input = File.read(ARGV[0]).split(' ').map(&:to_i)

class Node
  attr_reader :children, :metadata

  def initialize(children, metadata)
    @children = children
    @metadata = metadata
  end

  def total
    [*children.map(&:total), *metadata].inject(:+)
  end

  def value
    result = if children.empty?
      metadata.inject(:+)
    else
      metadata.map do |m|
        child = m == 0 ? nil : children[m - 1]
        child&.value || 0
      end.inject(:+)
    end
    result
  end
end

def parse(input)
  return nil if input.empty?

  child_count = input.shift
  meta_count = input.shift

  children = child_count.times.map { parse(input) }
  metadata = meta_count.times.map { input.shift }

  Node.new(children, metadata)
end

root = parse(input)
puts root.total
puts root.value
