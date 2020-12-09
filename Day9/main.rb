lines = File.open('9-input.txt').read.split("\n").map(&:to_i)

def sum?(arr, num)
  arr.each do |i|
    arr.each do |j|
      next if j == i
      return true if i + j == num
    end
  end
  false
end

def sweep(array, length)
  (length..array.length - 1).each do |i|
    num = array[i]
    sect = array.slice(i - length, length)
    next if sum?(sect, num)

    return num
  end
end

def contig_sum?(array, num)
  array.length.times do |i|
    sum = 0
    ind = i
    until sum >= num
      sum += array[ind]
      ind += 1
    end
    return array.slice(i..ind) if sum == num
  end
  false
end

# Pt 1 - find the first number that isn't a sum of any two numbers in the 25 previous numbers in the sequence
val = sweep(lines, 25)
p val

# Pt 2 - find the range of contiguous numbers that sums to the value from Pt 1
range = contig_sum?(lines, val)
p range
# actual answer is the sum of smallest/largest numbers in the range
p range.min + range.max
