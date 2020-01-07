#!/usr/bin/ruby

def all_fuel(mass)
  f = fuel(mass)
  return 0 if f <= 0
  return f + all_fuel(f)
end

def fuel(mass)
  (mass / 3).floor - 2
end

masses = File.readlines(ARGV[0]).map(&:to_i)
puts masses.map {|mass| fuel(mass)}.inject(:+)
puts masses.map {|mass| all_fuel(mass)}.inject(:+)
