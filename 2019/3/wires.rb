#!/usr/bin/env ruby

wire1, wire2 = File.readlines(ARGV[0]).map(&:strip).map{|line| line.split(',')}

def coords(wire)
  x, y = 0, 0
  coords = []

  wire.each do |segment|
    dir = segment[0]
    steps = segment[1..-1].to_i
    change = case dir
             when ?U then [0, 1]
             when ?D then [0, -1]
             when ?L then [-1, 0]
             when ?R then [1, 0]
             end
    steps.times do
      x += change[0]
      y += change[1]
      coords << [x, y]
    end
    #puts "#{segment} -> #{x}, #{y}"
  end

  coords
end

def dist(x, y)
  x.abs + y.abs
end

coords1 = coords(wire1)
coords2 = coords(wire2)
intersections = coords1 & coords2

distances = intersections.map {|(x, y)| dist(x, y)}
puts distances.min

steps = intersections.map do |(x, y)|
  coords1.index([x, y]) + coords2.index([x, y]) + 2 # 0-indexed -> step number
end
puts steps.min
