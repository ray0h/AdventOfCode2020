require_relative 'decoder'
require 'benchmark'

data = File.open('19-sbinput2.txt').read.split("\n").reject { |el| el == '' }

puts Benchmark.measure {
  decoder = Decoder.new(data)
  decoder.solve
  binding.pry
}
