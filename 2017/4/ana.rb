phrases = File.readlines(ARGV[0]).map(&:strip)

count = phrases.count do|p|
  words = p.split(' ')
  unique = words.size == words.uniq.size
  anagrams = words.size == words.map(&:chars).map(&:sort).uniq.size
  unique && anagrams
end

puts count
