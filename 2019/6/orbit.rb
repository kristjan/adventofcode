#!/usr/bin/env ruby

orbits = File.readlines(ARGV[0]).map(&:strip).map{|l| l.split(')') }

class System
  def initialize(orbits)
    @system = {}

    orbits.each do |center, body|
      @system[center] ||= nil
      @system[body] = center
    end
  end

  def depth(body)
    body == 'COM' ? 0 : 1 + depth(@system[body])
  end

  def checksum
    @system.keys.map do |body|
      depth(body)
    end.inject(:+)
  end

  def path_to(a, b)
    a == b ? [] : [@system[a], *path_to(@system[a], b)]
  end

  def transfers(a, b)
    a_path = path_to(a, 'COM')
    b_path = path_to(b, 'COM')
    root = (a_path & b_path).first
    a_path.index(root) + b_path.index(root)
  end
end

system = System.new(orbits)
puts system.checksum
puts system.transfers('YOU', 'SAN')
