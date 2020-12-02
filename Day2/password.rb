# str = '1-3 a: abcde'
# num = 1-3
# char = 'a'
# password = 'abcde'
# Pt 1 interprets valid passwords as those with 1-3 of the char in the password
# Here the password is invalid because it contains one instance of 'a'

def eval(str)
  str = str.split(' ')
  num = str[0].split('-').map(&:to_i)
  char = str[1][0]
  password = str[2]
  count = password.count(char)
  count >= num[0] && count <= num[1]
end

passwords = File.open('2-input.txt').read.split("\n")
total = 0

passwords.each do |string|
  total += 1 if eval(string)
end

p total
p passwords.length
