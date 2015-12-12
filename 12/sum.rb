require 'json'

data = JSON.parse(File.read(ARGV[0]))

def sum(data)
  case data
  when Hash
    return 0 if (data.keys + data.values).include?('red')
    data.values.map { |i| sum(i) }
  when Array  then data.map { |i| sum(i) }
  when Fixnum then [data]
  when String then [data.to_i]
  else
    raise "How do I sum #{data.class}?"
  end.inject(:+)
end

puts sum(data)
