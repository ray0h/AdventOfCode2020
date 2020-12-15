# First approach
# Using arrays as data structure.  Worked fine for the inital part one problem, but was quickly overwhelmed for Part 2.

class Game
  def initialize(start)
    @chain = start
  end

  def play(turns)
    (@chain.length + 1..turns).each do |turn|
      already_played? ? @chain.push(last_delta) : @chain.push(0)
      # p "Turn: #{turn}, #{@chain.last}"
    end
  end

  def last_turn
    puts @chain.last
  end

  private

  def already_played?
    @chain.slice(0..-2).include?(@chain.last)
  end

  def last_delta
    last_inst = 0
    prev = @chain.slice(0..-2)
    prev.each_with_index { |el, ind| last_inst = ind if el == @chain.last }
    (@chain.length - 1) - last_inst
  end
end
