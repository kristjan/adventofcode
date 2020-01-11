#!/usr/bin/env ruby

require_relative '../lib/computer.rb'

program = File.read(ARGV[0]).strip.split(',').map(&:to_i)

def run(program, phase_options, pause_on_output)
  max = 0
  max_phases = []

  phase_options.to_a.permutation.each do |phases|
    amps = Array.new(5) { Computer.new(program, pause_on_output) }
    amps.zip(phases).each do |amp, phase|
      amp.input(phase)
    end
    
    signal = 0
    i = 0
    e_out = 0
    while true
      amp = amps[i]
      amp.input(signal)
      r = amp.compute
      signal = amp.output
      e_out = signal if amp == amps.last
      i = (i + 1) % 5
      break if amp.halted?
    end

    if e_out > max
      max = e_out
      max_phases = phases
    end
  end

  return [max, max_phases]
end


if ARGV[1] == 0
  puts run(program, 0..4, false).inspect
else
  puts run(program, 5..9, true).inspect
end
