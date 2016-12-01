require 'set'

FORMAT = /(\w+) to (\w+) = (\d+)/

data = File.readlines(ARGV[0]).each(&:strip!)

graph = Hash.new { |h, k| h[k] = {} }
data.each do |line|
  raise "Format error: #{line}" unless FORMAT.match(line)
  from, to, distance = $1, $2, $3
  graph[from][to] = graph[to][from] = distance.to_i
end


routes = graph.keys.permutation(graph.size).map do |order|
  order.each_cons(2).map { |from, to| graph[from][to] }.inject(:+)
end

puts "Min: #{routes.min}"
puts "Max: #{routes.max}"
