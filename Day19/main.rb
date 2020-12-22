require_relative 'decoder2'
require 'benchmark'

data = File.open('19-input.txt').read.split("\n").reject { |el| el == '' }

puts Benchmark.measure {
  decoder = Decoder.new(data)
  decoder.solve_pt2
#   binding.pry
}
