START = <<-TXT
.#.
..#
###
TXT

data, iterations = ARGV.to_a
data = File.readlines(data)
iterations = iterations.to_i

def flip_horiz(rule)
  rule.split("\n").map(&:reverse).join("\n")
end

def flip_vert(rule)
  rule.split("\n").reverse.join("\n")
end

def rotate_once(rule)
  chars = rule.split("\n").map{|r| r.split('')}
  flip_horiz(chars.transpose.map(&:join).join("\n"))
end

def rotate(rule, n)
  n.times { rule = rotate_once(rule) }
  rule
end


def expand(rule)
  rotations = [
    rule,
    rotate(rule, 1),
    rotate(rule, 2),
    rotate(rule, 3),
  ]
  flips = rotations.map do |r|
    [
      flip_horiz(r),
      flip_vert(r)
    ]
  end.flatten
  (rotations + flips).uniq
end

def split(grid, size)
  result = []
  lines = grid.split("\n").map(&:chars)
  count = lines.size / size
  (count).times do |r|
    row = []
    (count).times do |c|
      cur = ''
      size.times do |i|
        size.times { cur << lines[size * r + i].shift }
        cur << "\n"
      end
      cur.chomp!
      row << cur
    end
    result << row
  end
  result
end

def join_row(row)
  result = []
  row.first.split("\n").size.times do |i|
    result[i] = ''
  end
  row.each do |block|
    block.split("\n").each.with_index do |line, i| result[i] += line
    end
  end
  result.join("\n")
end

def join(grid)
  grid.map { |row| join_row(row) }.join("\n")
end

rules = {}
data.each do |line|
  key, value = line.split('=>').map{|s| s.strip.gsub('/', "\n")}
  expand(key).each do |k|
    rules[k] = value
  end
end

#puts rules.keys.join("\n==\n")
#exit

cur = START.dup
iterations.times do
  split_size = cur.split("\n").size % 2 == 0 ? 2 : 3
  intermediate = split(cur, split_size)
  transformation = intermediate.map do |row|
    row.map do |block|
      rules[block]
    end
  end
  cur = join(transformation)
end


puts cur.split("\n").flat_map(&:chars).select{|ch| ch == '#'}.size
