spec = File.readlines(ARGV[0]).each(&:strip!)

connections = Hash[
  spec.map do |s|
    s.split(/\w*->\w*/).each(&:strip!)
  end.map(&:reverse)
]

def flip(n)
  puts "\tFlipping #{n}"
  15.downto(0).map { |i| 1 - n[i] }.join.to_i(2)
end

results = Hash.new do |h, k|
  puts "Getting #{k}"
  if k =~ /^\d+$/
    puts "\tInt #{k.to_i}"
    h[k] = k.to_i
  else
    expr = connections[k]
    puts "\tExpr: #{expr}"
    h[k] =
      case expr
      when /NOT (\w+)/
        flip(h[$1])
      when /(\w+) AND (\w+)/
        left, right = $1, $2
        h[left] & h[right]
      when /(\w+) OR (\w+)/
        left, right = $1, $2
        h[left] | h[right]
      when /(\w+) LSHIFT (\w+)/
        left, right = $1, $2
        h[left] << h[right]
      when /(\w+) RSHIFT (\w+)/
        left, right = $1, $2
        h[left] >> h[right]
      else h[expr]
      end
  end
end

puts results[ARGV[1]]
