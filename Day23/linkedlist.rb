require 'pry'
require_relative 'node'

class LinkedList
  def initialize(inp_str, max = inp_str.length)
    @segment = inp_str.chars.map(&:to_i)
    @current = Node.new(@segment.shift)
    @last = @current
    @min = @segment.min
    @max = max
    @set_first = nil
    @set_last = nil
    lay_circle
  end

  def move
    @set_first = @current.next_node
    # pull set from circle
    define_set

    subset = subset_array
    # grab destination
    dest = (@current.value - 1) >= @min ? @current.value - 1 : @max
    dest = dest > @min ? dest - 1 : @max while subset.include?(dest)
    # insert set
    insert_set(dest)

    # set new current
    @current = @current.next_node
  end

  def subset_array
    [@set_first.value, @set_first.next_node.value, @set_last.value]
  end

  def define_set
    return nil if @set_first.nil?

    set_middle = @set_first.next_node
    @set_last = set_middle.next_node
    # sever subset from list
    @current.next_node =  @set_last.next_node
    @set_last.next_node = nil
  end

  def insert_set(dest)
    temp = @current
    temp = temp.next_node until temp.value == dest
    @set_last.next_node = temp.next_node
    temp.next_node = @set_first
  end

  def lay_circle
    # link initial segments into list
    @segment.each { |value| append(value) }
    # add add'l sequential values if specified (..@max)
    (@segment.length + 1..@max).to_a.each { |value| append(value) } if @max > @segment.length + 1
    # complete the circle
    @last.next_node = @current
  end

  def append(value)
    temp = @current
    temp = temp.next_node until temp == @last
    @last = Node.new(value)
    @last.next_node = temp.next_node
    temp.next_node = @last
  end

  def size
    count = 1
    temp = @current
    until temp.next_node == @current
      count += 1
      temp = temp.next_node
    end
    count
  end

  def print(adjone = false)
    arr = []
    temp = @current
    size.times do
      arr.push(temp.value)
      temp = temp.next_node
    end
    if adjone
      arr = arr.rotate until arr.first == 1
    end
    p arr
  end
end
