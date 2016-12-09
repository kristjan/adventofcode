lines = File.read(ARGV[0]).split("\n")

lines.each do |line|
  puts '#' + line
  output = ''
  input = line.chars

  while input.any?
    ch = input.shift
    case ch
    when '('
      length = ''

      while (ch = input.shift) != 'x'
        length << ch
      end
      length = length.to_i
      count = ''

      while (ch = input.shift) != ')'
        count << ch
      end
      count = count.to_i

      repeat = ''
      puts "Repeating #{repeat} (#{length}) x #{count}"
      length.times { repeat << input.shift }
      count.times { output << repeat }
    else
      output << ch
    end
  end

  puts output
  puts output.size
end
