class Graph
  attr_accessor :segment, :graph, :current
  def initialize(inp_str, max)
    @string = inp_str
    @segment = inp_str.chars.map(&:to_i)
    @min = @segment.min
    @max = max
    @current = @segment.first
    @graph = init_graph
    @set_first = -1
    @set_last = -1
  end

  def move
    # establish set
    current_set = current_set()

    # pull set from circle
    @graph[@current] = @graph[@set_last] ||= @set_last + 1

    # find destination
    dest = (@current - 1) >= @min ? @current - 1 : @max
    # binding.pry if dest.zero?
    dest = dest > @min ? dest - 1 : @max while current_set.include?(dest)

    # insert set
    hook = @graph[dest] ||= dest + 1
    @graph[dest] = @set_first
    @graph[@set_last] = hook

    # set new @current
    @current = @graph[@current] ||= @current + 1
  end

  def current_set
    @set_first = @graph[@current] ||= @current + 1
    @set_second = @graph[@set_first] ||= @set_first + 1
    @set_last = @graph[@set_second] ||= @set_second + 1
    [@set_first, @set_second, @set_last]
  end

  # create and fill circle graph with values/order in initial segment
  # remaining numbers are initially not set in graph and sequential
  # the largest value in the segment points to the first 'unestablished' value and max value points to @current
  # to close the circle
  def init_graph
    graph = {}
    @segment.each.with_index do |num, ind|
      graph[num] = @segment[ind + 1]
      graph[num] = @segment.max + 1 if ind == @segment.length - 1
    end
    graph[@max] = @current
    graph
  end

  def print(adjone = false)
    array = [@current]
    value = @current
    until @graph[value] == @current
      array.push(@graph[value] ||= value + 1)
      value = array.last
    end
    if adjone
      array = array.rotate until array.first == 1
    end
    p array
  end

  def print_adjone
    p [@graph[1], @graph[@graph[1]]]
  end
end
