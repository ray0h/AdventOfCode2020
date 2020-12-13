class Ship
  attr_accessor :heading, :coord
  def initialize(course)
    @course = course
    @coord = [0, 0]
    @waypoint = [10, 1]
  end

  def chart
    @course.each do |instruc|
      dir, val = parse_instruc(instruc)
      case dir
      when 'F'
        move(val)
      when 'L', 'R'
        rotate_waypoint(dir, val)
      else
        move_waypoint(dir, val)
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

  def rotate_waypoint(dir, deg)
    x = @waypoint[0]
    y = @waypoint[1]
    headings = [[x, y], [y, -x], [-x, -y], [-y, x]]
    # current ind of heading
    ind = headings.index(@waypoint)
    # num dir to rotate
    num = deg / 90
    # add/sub based on rot direction
    new_ind = dir == 'R' ? ind + num : ind - num
    # moduolo accounts for multiple rotations (eg 720 deg)
    mod = dir == 'R' ? 4 : -4
    @waypoint = headings[new_ind % mod]
  end

  def move_waypoint(dir, dist)
    case dir
    when 'E'
      @waypoint[0] += dist
    when 'W'
      @waypoint[0] -= dist
    when 'N'
      @waypoint[1] += dist
    when 'S'
      @waypoint[1] -= dist
    end
  end

  def move(times)
    times.times do
      @coord[0] += @waypoint[0]
      @coord[1] += @waypoint[1]
    end
  end
end
