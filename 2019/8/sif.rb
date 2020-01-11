#!/usr/bin/env ruby

width, height = 25, 6

data = File.read(ARGV[0]).strip.split('').map(&:to_i)

layers = []
while data.any?
  layer = []
  height.times { layer << data.shift(width) }
  layers << layer
end

min_layer = layers.min_by {|layer| layer.flatten.count(&:zero?)}
puts min_layer.flatten.count{|i| i == 1} * min_layer.flatten.count{|i| i == 2}

final = layers.pop
while layers.any?
  layer = layers.pop
  final = final.zip(layer).map do |bottom, top|
    bottom.zip(top).map do |bp, tp|
      tp == 2 ? bp : tp
    end
  end
end
puts final.map(&:join).join("\n").tr('01', ' #')
