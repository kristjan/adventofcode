#!/usr/bin/ruby

min, max = File.read(ARGV[0]).strip.split('-').map(&:to_i)

def valid?(i)
  double = false
  i.to_s.chars.each_cons(2) do |a, b|
    double = true if a == b
    return false if a.to_i > b.to_i
  end
  return double
end

def extra_valid?(i)
  double = false
  i.to_s.chars.each_cons(2) do |a, b|
    double = true if a == b && !i.to_s.match(/#{a}{3,}/)
    return false if a.to_i > b.to_i
  end
  return double
end

puts min.upto(max).count {|i| valid?(i)}

puts min.upto(max).count {|i| extra_valid?(i)}
