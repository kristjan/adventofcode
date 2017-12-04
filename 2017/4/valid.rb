phrases = File.readlines(ARGV[0]).map(&:strip)

count = phrases.count do|p|
  words = p.split(' ')
  words.size == words.uniq.size
end

puts count
