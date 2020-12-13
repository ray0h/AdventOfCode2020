class Ship
  attr_accessor :heading, :coord
  def initialize(course)
    @course = course
    @heading = 'E'
    @headings = %w[N E S W]
    @coord = [0, 0]
  end

  def chart
    @course.each do |instruc|
      dir, val = parse_instruc(instruc)
      case dir
      when 'F'
        move(@heading, val)
      when 'L', 'R'
        rotate(dir, val)
      else
        move(dir, val)
      end
    end
  end

  def manhattan
    @coord[0].abs + @coord[1].abs
  end

  private

  def parse_instruc(instruc)
    dir = instruc[0]
    dist = instruc.slice(1..-1).to_i
    [dir, dist]
  end

  def rotate(dir, deg)
    # current ind of 2heading
    ind = @headings.index(@heading)
    # num dir to rotate
    num = deg / 90
    # add/sub based on rot direction
    new_ind = dir == 'R' ? ind + num : ind - num
    # moduolo accounts for multiple rotations (eg 720 deg)
    mod = dir == 'R' ? 4 : -4
    @heading = @headings[new_ind % mod]
  end

  def move(dir, dist)
    case dir
    when 'E'
      @coord[0] += dist
    when 'W'
      @coord[0] -= dist
    when 'N'
      @coord[1] += dist
    when 'S'
      @coord[1] -= dist
    end
  end
end
