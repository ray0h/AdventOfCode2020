# Second approach using hashes; this sped performance up considerably, but was still too slow.

class Game2
  def initialize(start)
    @chain = start_chain(start)
    @last = start.last
    @starting = start.length
    # binding.pry
  end

  def play(turns)
    (@starting..turns - 1).each do |turn|
      if in_chain?
        delta = turn - @chain[@last]
        @chain[@last] = turn
        @last = delta
      else
        @chain[@last] = turn
        @last = 0
      end
      # p turn if turn % 50000 == 0
      # p "Turn: #{turn}, #{@last}"
    end
  end

  def last_turn
    puts @last
  end

  private

  def in_chain?
    @chain.keys.include?(@last)
  end

  def start_chain(start)
    start = start.clone
    start.pop
    chain = {}
    start.each_with_index { |el, ind| chain[el] = ind + 1 }
    chain
  end
end
