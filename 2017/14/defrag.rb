key = 'wenycdww'

def hash(input)
  input = input.chars.map(&:ord)
  input.concat([17, 31, 73, 47, 23])
  size = 256
  list = Array.new(size) { |i| i }

  cur = 0
  skip = 0

  64.times do |iteration|
    input.each do |len|
      left, right = cur, (cur + len - 1) % size
      (len / 2).times do
        list[left], list[right] = list[right], list[left]
        left = (left + 1) % size
        right -= 1
        right += size if right < 0
      end
      cur = (cur + len + skip) % size
      skip += 1
    end
  end

  dense = []
  while list.any?
    set = list[0...16]
    list = list[16..-1]
    dense << set.inject(:^)
  end

  dense.map { |i| i.to_s(16).rjust(2, '0') }.join
end

rows = Array.new(128) do |i|
  hash("#{key}-#{i}")
end

used = 0
grid = rows.map do |row|
  binary = row.chars.map{|ch| ch.hex.to_s(2).rjust(4, '0')}
  binary.join('')
end
grid.each do |row|
  row.chars.each do |b|
    used += 1 if b == '1'
  end
end

puts "Used: #{used}"

mem = grid.map do |row|
  row.split('').map {|i| i == '1'}
end

def neighbors(row, col)
  [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
  ]
    .map { |x, y| [row + x, col + y] }
    .select do |x, y|
    x >= 0 && y >= 0 && x < 128 && y < 128
  end
end

regions = 0
mem.size.times do |row|
  mem[row].size.times do |col|
    next unless mem[row][col] # Unused
    next if mem[row][col].is_a?(Integer) # Assigned

    regions += 1 # Found a new one
    region = regions # Currnet
    to_fill = [[row, col]]

    while to_fill.any?
      crow, ccol = to_fill.shift
      mem[crow][ccol] = region

      ns = neighbors(crow, ccol)

      ns.each do |nrow, ncol|
        next unless mem[nrow][ncol]
        next if mem[nrow][ncol].is_a?(Integer)
        other = [nrow, ncol]
        to_fill << other
      end
    end
  end
end

puts "Regions: #{regions}"
