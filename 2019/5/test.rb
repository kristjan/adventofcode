#!/usr/bin/env/ruby

require_relative '../lib/computer'

program = File.read(ARGV[0]).strip.split(',').map(&:to_i)

ac = Computer.new(program)
ac.manual_input(1)
ac.compute

radiators = Computer.new(program)
radiators.manual_input(5)
radiators.compute
