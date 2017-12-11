data = File.read(ARGV[0])

def score(chars)
  total = 0
  group_score = 0
  garbage_count = 0
  garbage = false
  while chars.any?
    ch = chars.shift
    if garbage
      case ch
      when '>' then garbage = false
      when '!' then chars.shift
      else
        garbage_count += 1
      end
    else
      case ch
      when '{' then group_score += 1
      when '}'
        total += group_score
        group_score -= 1
      when '!' then chars.shift
      when '<' then garbage = true
      end
    end
  end
  [total, garbage_count].inspect
end

puts score(data.chars)
