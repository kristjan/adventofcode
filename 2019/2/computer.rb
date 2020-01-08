#!/usr/bin/env ruby

require_relative '../lib/computer'

input = File.read(ARGV[0]).strip().split(',').map(&:to_i)
input[1], input[2] = 12, 2
puts Computer.new(input).compute

def search(input, target)
	(0..99).each do |noun|
		(0..99).each do |verb|
			current_input = input.dup
			current_input[1], current_input[2] = noun, verb
			result = Computer.new(current_input).compute
			return [noun, verb] if result == target
		end
	end
end
target = File.read(ARGV[1]).to_i
noun, verb = search(input.dup, target)
puts (100 * noun) + verb
