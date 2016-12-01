FORMAT = /(?<action>.*) (?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)/

def parse(cmd)
  FORMAT.match(cmd).captures.tap do |match|
    match[1..-1] = match[1..-1].map(&:to_i)
  end
end

grid = Array.new(1000) do
  Array.new(1000) { 0 }
end

commands = File.readlines(ARGV[0])

commands.each do |cmd|
  action, x1, y1, x2, y2 = parse(cmd)
  (x1..x2).each do |x|
    (y1..y2).each do |y|
      new_value = case action
      when 'turn on'  then 1
      when 'turn off' then 0
      when 'toggle'   then 1 - grid[x][y]
      else
        raise "Unknown action #{action}"
      end
      grid[x][y] = new_value
    end
  end
end

puts grid.flatten.count { |i| i == 1 }
