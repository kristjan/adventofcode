input = File.read(ARGV[0]).strip.chars

alphabet = input.map(&:downcase).uniq

def react(input)
  input = input.dup

  while true
    cur = input.dup

    0.upto(input.size - 2).each do |i|
      a, b = input[i..(i+1)]
      break if [a, b].any?(&:nil?)

      if a.downcase == b.downcase && a != b
        input[i..(i+1)] = []
      end
    end

    break if input == cur
  end

  input
end

puts react(input).size

min = Float::INFINITY
alphabet.each do |letter|
  puts "Removing #{letter}"
  nixed = input - [letter] - [letter.upcase]
  result = react(nixed)
  min = result.size if result.size < min
  puts "Min: #{min}"
end

puts min
