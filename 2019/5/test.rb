#!/usr/bin/env/ruby

require_relative '../lib/computer'

program = File.read(ARGV[0]).strip.split(',').map(&:to_i)

ac = Computer.new(program)
10.times { ac.input(1) }
ac.compute
puts ac.output while ac.output?

radiators = Computer.new(program)
10.times { radiators.input(5) }
radiators.compute
puts radiators.output while radiators.output?
