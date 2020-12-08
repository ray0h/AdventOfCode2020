require 'pry'

f = File
    .open('8-input.txt')
    .read
    .split("\n")
    .map { |el| el.split(' ') }
    .map { |el| [el.first, el.last.to_i]}

def test(f)
  lines = [0]
  acc = 0
  i = 0
  loop do
    com = f[i]
    if com.first == 'nop'
      i += 1
    elsif com.first == 'acc'
      acc += com.last
      i += 1
    elsif com.first == 'jmp'
      i += com.last
    end
    lines.push(i)
    return ['inf loop', acc] if lines.uniq.length != lines.length
    return ['made it through', acc] if lines.include?(f.length)
    # break if lines.uniq.length != lines.length || lines.include?(f.length)
  end
end

# Part 1 find acc value before prgm starts inf loop
p test(f)

# Part 2 brute force changing the one 'jmp' -> 'nop' or 'nop' -> 'jmp' to allow program to run to completion

nops = f.select{ |el| el.first == 'nop' }.map { |el| f.index(el) }
jmps = f.select{ |el| el.first == 'jmp' }.map { |el| f.index(el) }

nops.each do |ind|
  g = f.map(&:clone)
  g[ind][0] = 'jmp'
  txt, acc = test(g)
  p acc if txt == 'made it through'
  p ind if txt == 'made it through'
end

jmps.each do |ind|
  g = f.map(&:clone)
  g[ind][0] = 'nop'
  # binding.pry
  txt, acc = test(g)
  p acc if txt == 'made it through'
  p ind if txt == 'made it through'
end
