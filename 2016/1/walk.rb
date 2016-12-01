require 'set'

input = File.read(ARGV[0]).split(', ')

x = y = 0
dirs = %i[north east south west]

seen = Set.new
seen << [0, 0]

done = false
input.each do |i|
  turn = i[0]
  distance = i[1..-1].to_i
  puts "Turning #{turn}, Moving #{distance}"
  spin = turn == 'R' ? 1 : -1
  dirs = dirs.rotate(spin)

  current = dirs.first
  puts "Moving #{current}"
  distance.times do
    case current
    when :north then y += 1
    when :west  then x -= 1
    when :south then y -= 1
    when :east  then x += 1
    end

    if seen.include?([x, y])
      done = true
      break
    end
    seen << [x, y]
    puts [x, y].join(', ')
  end
  break if done
end

puts x.abs + y.abs
