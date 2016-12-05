require 'digest'

PASSWORD_LENGTH = 8

door_id = ARGV[0]

password = ''
i = 0

while password.length < PASSWORD_LENGTH
  attempt = "#{door_id}#{i}"
  hash = Digest::MD5.new
  hash << attempt
  result = hash.hexdigest

  if result[0...5] == '00000'
    ch = result[5]
    puts [i, ch].inspect
    password += result[5]
  end

  i += 1
end

puts password
