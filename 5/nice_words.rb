BLACKLIST = %w[ab cd pq xy]
VOWELS = %w[a e i o u]

def three_vowels?(word)
  word.chars.count { |ch| VOWELS.include?(ch) } >= 3
end

def doubled_letter?(word)
  word.chars.each_cons(2).any? { |a, b| a == b }
end

def blacklisted?(word)
  BLACKLIST.any? { |item| word.include?(item) }
end

def nice?(word)
  three_vowels?(word) && doubled_letter?(word) && !blacklisted?(word)
end

puts File.readlines(ARGV[0]).map(&:strip).count { |word| nice?(word) }
