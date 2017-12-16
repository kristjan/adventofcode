steps = File.read(ARGV[0]).strip.split(',')

IN_ORDER = (?a..?p).to_a.freeze

line = (?a..?p).to_a

def dance!(line, steps)
  steps.each do |step|
    case step.chars[0]
    when ?s
      count = step[1..-1].to_i
      line = line[-count..-1] + line[0...-count]
    when ?x
      ai, bi = step[1..-1].split('/').map(&:to_i)
      line[ai], line[bi] = line[bi], line[ai]
    when ?p
      a, b = step[1..-1].split('/')
      ai = line.index(a)
      bi = line.index(b)
      line[ai], line[bi] = line[bi], line[ai]
    end
  end
  line
end

line = dance!(line, steps)
puts line.join

cycle = 1
loop do
  cycle += 1
  line = dance!(line, steps)
  break if line == IN_ORDER
end
puts cycle

_loops, rest = 1_000_000_000.divmod(cycle)
rest.times { line = dance!(line, steps) }

puts line.join
