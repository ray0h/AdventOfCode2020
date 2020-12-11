class WaitAreaModel
  def initialize
    @empty = File.open('11-input.txt').read.split("\n").map(&:chars)
    @seats = fill_all(@empty)
  end

  def cycle
    temp = @seats.map(&:clone)
    @seats.length.times do |i|
      @seats[i].length.times do |j|
        next if @seats[i][j] == '.'

        neighbors = neighbors([i, j])
        temp[i][j] = 'L' if crowded?([i, j], neighbors)
        temp[i][j] = '#' if empty?([i, j], neighbors)
      end
    end
    @seats = temp
  end

  def print
    @seats.length.times { |i| p @seats[i].join('') }
  end

  def count_filled
    @seats.flatten.count('#')
  end

  private

  def fill_all(seats)
    seats.map do |row|
      row.map { |seat| seat == 'L' ? '#' : seat }
    end
  end
  
  # is sqr within the waiting area grid?
  def inbounds?(sqr)
    sqr[0] >= 0 && sqr[1] >= 0 && sqr[0] < @seats.length && sqr[1] < @seats[0].length
  end

  # returns valid, ADJACENT surrounding sqrs
  def surrounding(sqr)
    surround = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
    surround.map { |addn| adj_sqr(sqr, addn) }.reject { |el| el == 'rej' }
  end

  # returns count of filled ADJACENT seats surrounding sqr
  def neighbors(sqr)
    around = surrounding(sqr)
    around.map { |coord| @seats[coord[0]][coord[1]] }.count('#')
  end

  def adj_sqr(sqr, addn)
    inbounds?([sqr[0] + addn[0], sqr[1] + addn[1]]) ? [sqr[0] + addn[0], sqr[1] + addn[1]] : 'rej'
  end

  def crowded?(sqr, neighbors)
    @seats[sqr[0]][sqr[1]] == '#' && neighbors >= 4
  end

  def empty?(sqr, neighbors)
    @seats[sqr[0]][sqr[1]] == 'L' && neighbors.zero?
  end
end
