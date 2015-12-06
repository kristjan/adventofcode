dimensions = File.readlines(ARGV[0]).map do |line|
  line.strip.split('x').map(&:to_i)
end

swaths = dimensions.map do |l, w, h|
  surfaces = [
    l * w,
    w * h,
    l * h
  ]
  surfaces.inject(:+) * 2 + surfaces.min
end

puts swaths.inject(:+)
