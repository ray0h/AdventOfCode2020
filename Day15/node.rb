# Node
class Node
  include Comparable
  def <=>(other)
    value <=> other.value
  end

  attr_accessor :left, :right, :value, :ind
  def initialize(value = nil, ind = nil, left = nil, right = nil)
    @value = value
    @ind = ind
    @left = left
    @right = right
  end
end
