#!/usr/bin/env ruby

def compute(input)
	ip = 0
	cmd = nil

	while true
		cmd, left, right, save = input[ip..(ip+3)]
		# puts input.join(',')
		# puts [ip, '>', cmd, left, right, save].join(',')
		# puts
		case cmd
		when 1
			input[save] = input[left] + input[right]
		when 2
			input[save] = input[left] * input[right]
		when 99
			return input[0]
		else
			raise "Bad cmd #{cmd} at #{ip}"
		end
		ip += 4
	end
end

input = File.read(ARGV[0]).strip().split(',').map(&:to_i)
input[1], input[2] = 12, 2
puts compute(input.dup)

def search(input, target)
	(0..99).each do |noun|
		(0..99).each do |verb|
			current_input = input.dup
			current_input[1], current_input[2] = noun, verb
			result = compute(current_input)
			return [noun, verb] if result == target
		end
	end
end
target = File.read(ARGV[1]).to_i
noun, verb = search(input.dup, target)
puts (100 * noun) + verb
