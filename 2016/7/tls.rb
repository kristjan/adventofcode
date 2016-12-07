data = File.readlines(ARGV[0])

def palindromes?(str)
  str.chars.each_cons(4).any? do |a, b, c, d|
    a == d && b == c && a != b
  end
end

count = data.count do |line|
  abba = palindromes?(line)
  cancel = line.scan(/\[[^\]]+\]/).to_a.any? do |interior|
    palindromes?(interior)
  end
  abba && !cancel
end

puts "TLS: #{count}"

def ssl?(str)
  exterior = str.gsub(/\[[^\]]*\]/, '-')
  abas = exterior.chars.each_cons(3).to_a.select do |a, b, c|
    ![a, b, c].include?('-') && a == c && a != b
  end

  interiors = str.scan(/\[[^\]]+\]/).to_a

  verify = interiors.any? do |interior|
    abas.any? do |a, b, c|
      interior.include?("#{b}#{a}#{b}")
    end
  end

  verify
end

count = data.count { |line| ssl?(line) }

puts "SSL: #{count}"
