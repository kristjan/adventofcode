containers = File.readlines(ARGV[0]).map(&:to_i)
target = ARGV[1].to_i

combinations = []

def find_combinations(combinations, current, containers, target)
  combinations << current if target == 0
  return if target <= 0
  return if containers.empty?
  find_combinations(combinations, current, containers[1..-1], target)
  find_combinations(combinations, current + [containers[0]], containers[1..-1], target - containers[0])
end

find_combinations(combinations, [], containers, target)
puts "Combinations: #{combinations.size}"
min = combinations.map(&:size).min
puts "Minimum size: #{min}"
min_combinations = combinations.select { |c| c.size == min }
puts "Minimum combinations: #{min_combinations.size}"
