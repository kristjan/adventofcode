#!/usr/bin/env ruby

require_relative '../lib/computer.rb'

program = File.read(ARGV[0]).strip.split(',').map(&:to_i)

(1..2).each do |init|
  computer = Computer.new(program)
  computer.input(init)
  computer.compute
  puts computer.output while computer.output?
end
