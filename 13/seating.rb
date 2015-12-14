data = File.readlines(ARGV[0]).each(&:strip!)
with_me = !!ARGV[1]

FORMAT = /(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)/

happiness = Hash.new { |h, k| h[k] = {} }
data.each do |line|
  a, sign, amount, b = FORMAT.match(line).captures
  amount = amount.to_i
  happiness[a][b] = (sign == 'gain' ? amount : -amount)
  if with_me
    happiness[a]['Kristján'] = 0
    happiness['Kristján'][a] = 0
  end
end

def total_happiness(happiness, names)
  score = 0
  names = names.dup.push(names.first)
  names.each_cons(2).each do |a, b|
    score += happiness[a][b]
    score += happiness[b][a]
  end
  score
end

names = happiness.keys
best, best_score = names, total_happiness(happiness, names)
names.permutation do |arrangement|
  score = total_happiness(happiness, arrangement)
  best, best_score = arrangement, score if score > best_score
end

puts best.inspect
puts best_score
