# str = '1-3 a: abcde'
# num = 1-3
# char = 'a'
# password = 'abcde'
# Pt 2 reinterprets password validity.  Here the numbers represent the positions (0 ind = 1)
# to evaluate.  Exactly one of these positions in the password should equal the char.
# Here, str is valid since 1 ('a') and 3 ('c') contains exactly one 'a' between the two.

def eval(str)
  str = str.split(' ')
  num = str[0].split('-').map(&:to_i)
  char = str[1][0]
  password = str[2]
  first = password[num[0] - 1]
  second = password[num[1] - 1]
  (first == char && second != char) || (first != char && second == char)
end

passwords = File.open('2-input.txt').read.split("\n")
total = 0

passwords.each do |string|
  total += 1 if eval(string)
end

p total
p passwords.length