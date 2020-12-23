require 'pry'

# Only relevant for Part 1 - would be very inefficient for Part 2
class Arrays
  def initialize(inp_str)
    @cups = inp_str.chars.map(&:to_i)
    @length = @cups.length
    @current = @cups[0]
    @min = @cups.min
  end

  def move
    # find set and pull from circle
    remaining = @cups - subset
    # find destination to insert the set
    dest_id = find_dest(remaining)
    dest_ind = remaining.index(dest_id)
    # insert the set
    @cups = remaining.insert(dest_ind + 1, subset).flatten
    # get next @current value
    @current = @cups[(@cups.index(@current) + 1) % @length]
  end

  def subset
    cur_index = @cups.index(@current)
    [1, 2, 3].map { |offset| @cups[(cur_index + offset) % @length] }
  end

  def find_dest(remains)
    diff = @current - 1
    diff = diff >= @min ? diff - 1 : @length until remains.include?(diff)
    diff
  end

  # rotate array till '1' is first
  def adjones
    @cups = @cups.rotate until @cups.first == 1
  end

  def print
    p @cups
  end
end
