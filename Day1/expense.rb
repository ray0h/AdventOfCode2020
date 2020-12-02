require 'benchmark'

f = File.open('1-input.txt')
arr = f.read.split("\n").map(&:to_i)

def pair(arr)
  arr.length.times do |i|
    (i..arr.length - 1).each do |j|
      return [arr[i], arr[j]] if arr[i] + arr[j] == 2020
    end
  end
end

# Pt 1
# puts Benchmark.measure {
#   i, j = pair(arr)
#   p i
#   p j
#   p i * j
# }
  
def triple(arr)
  arr.length.times do |i|
    (i..arr.length - 1).each do |j|
      (j..arr.length - 1).each do |k|
        return [arr[i], arr[j], arr[k]] if arr[i] + arr[j] + arr[k] == 2020
      end
    end
  end
end

# Pt2
puts Benchmark.measure {
  i, j, k = triple(arr)
  p i
  p j
  p k
  p i * j * k
}
