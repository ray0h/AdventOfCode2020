require_relative 'model'

class WaitAreaReal < WaitAreaModel
  private

  # returns valid, surrounding seats IN VIEW of 'sqr'
  def surrounding(sqr)
    surround = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
    surround.map { |addn| line_of_sight_sqr(sqr, addn) }.reject { |el| el == 'rej' }
  end

  # returns count of surrounding filled seats IN VIEW of 'sqr'
  def neighbors(sqr)
    around = surrounding(sqr)
    around.map { |coord| @seats[coord[0]][coord[1]] }.count('#')
  end

  # real life - ppl move if 5+ seats are occupied
  def crowded?(sqr, neighbors)
    @seats[sqr[0]][sqr[1]] == '#' && neighbors >= 5
  end

  # instead of adjacent sqrs, find the relevant squares in line of sight
  def line_of_sight_sqr(sqr, addn)
    last_sqr = [sqr[0] + addn[0], sqr[1] + addn[1]]
    next_sqr = last_sqr.clone
    return 'rej' unless inbounds?(next_sqr)

    until !inbounds?(next_sqr) || @seats[last_sqr[0]][last_sqr[1]] != '.'
      last_sqr = next_sqr.clone
      next_sqr = [last_sqr[0] + addn[0], last_sqr[1] + addn[1]]
    end
    last_sqr
  end
end
