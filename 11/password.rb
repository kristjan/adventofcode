password = ARGV[0]

def confusing_letters?(password)
  (password.chars & %w[i o l]).any?
end

def increment(password)
  chars = password.chars
  index = chars.size - 1
  begin
    if chars[index] == ?z
      chars[index] = 'a'
      index -= 1
    else
      chars[index] = (chars[index].ord + 1).chr
      break
    end
  end while index >= 0
  chars.join
end

def pairs?(password)
  password.chars.each_cons(2).select{|a, b| a == b}.uniq.size > 1
end

def straight?(password)
  password.chars.each_cons(3).any? do |letters|
    letters.map(&:ord).map {|l| l - letters.first.ord} == [0, 1, 2]
  end
end

def valid?(password)
  !confusing_letters?(password) && straight?(password) && pairs?(password)
end

begin
  password = increment(password)
end until valid?(password)

puts password
