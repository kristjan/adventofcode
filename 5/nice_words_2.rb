def repeated_pair?(word)
  word =~ /(?<pair>..).*\k<pair>/
end

def separated_letter?(word)
  word.chars.each_cons(3).any? { |a, b, c| a == c }
end

def nice?(word)
  repeated_pair?(word) && separated_letter?(word)
end

puts File.readlines(ARGV[0]).map(&:strip).count { |word| nice?(word) }
