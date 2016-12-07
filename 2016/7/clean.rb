data = File.readlines(ARGV[0]).each(&:chomp!)

BRACKETED = /\[[^\]]*\]/

def abas(str)
  str.chars.each_cons(3).to_a.select do |a, b, c|
    a == c && a != b
  end
end

def abbas(str)
  str.chars.each_cons(4).select do |a, b, c, d|
    a == d && b == c && a != b
  end
end

def exteriors(str)
  str.gsub(BRACKETED, '-').split('-')
end

def interiors(str)
  str.scan(BRACKETED).to_a.map { |s| s[1...-1] }
end

def invert(str)
  a, b = str.first(2)
  [b, a, b]
end

def tls?(str)
  exteriors(str).map(&method(:abbas)).flatten(1).any? &&
  interiors(str).map(&method(:abbas)).flatten(1).empty?
end

def ssl?(str)
  (
    exteriors(str).map(&method(:abas)).flatten(1) &
    interiors(str).map(&method(:abas)).flatten(1).map(&method(:invert))
  ).any?
end

puts "TLS: #{data.count(&method(:tls?))}"
puts "SSL: #{data.count(&method(:ssl?))}"
