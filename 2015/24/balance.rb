require 'set'

class Array
  def product
    inject(:*)
  end

  def sum
    inject(:+) || 0
  end
end

packages = File.readlines(ARGV[0]).map(&:to_i)
groups = ARGV[1].to_i
TARGET_WEIGHT = packages.sum / groups

def subsets(packages, current, target, sets)
  return if target < 0

  if target == 0
    sets << current
    return
  end

  return if packages.empty?

  package = packages.pop
  subsets(packages, [*current, package], target - package, sets)
  subsets(packages, current, target, sets)
  packages.push(package)
end

options = Set.new
subsets(packages, [], TARGET_WEIGHT, options)
puts "#{options.size} options"

options_by_size = options.group_by(&:size)
min_size = options_by_size.keys.min
min_options = options_by_size[min_size]
puts "Min count: #{min_size}, #{min_options.size} options"

puts "Min QE: #{min_options.map(&:product).min}"
