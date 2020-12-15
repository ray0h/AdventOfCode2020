require 'benchmark'
require_relative 'game'
require_relative 'game2'
require_relative 'game3'

start = [0,5,4,1,10,14,7]

times = 2020

puts Benchmark.measure {
  memory = Game.new(start)
  memory.play(times)
  memory.last_turn
}

puts Benchmark.measure {
  memory = Game2.new(start)
  memory.play(times)
  memory.last_turn
}

puts Benchmark.measure {
  memory = Game3.new(start)
  memory.play(times)
  memory.last_turn
}
