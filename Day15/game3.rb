# last approach involved using BST's for traversing through and finding game values.  It was interesting to see
# at lower iterations how the BST algorithm lagged, but was increasingly faster as the number of iterations
# went up.  Even with this approach, it still took ~20 min for the 'game'/program to run.  

require_relative 'node'

class Game3
  def initialize(start)
    @starting = start.length
    @last = start.last

    @start = start.slice(0..-2).sort
    @chain = start_hash(start)
    @root = build_tree(@start)
  end

  def play(turns)
    (@starting..turns - 1).each do |turn|
      if in_tree?
        node = in_tree?
        delta = turn - node.ind
        node.ind = turn
        @last = delta
      else
        insert(@last, turn)
        @last = 0
      end
      # p turn if turn % 50000 == 0
      # p "Turn: #{turn}, #{@last}"
    end
  end

  def last_turn
    puts @last
  end

  def in_tree?
    find(@last)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def start_hash(start)
    hash = {}
    start.each_with_index { |el, ind| hash[el] = ind + 1 }
    hash
  end

  def build_tree(array, startpt = 0, endpt = (array.length - 1))
    return nil if startpt > endpt

    midpt = (endpt - startpt) / 2
    last = array.length.even? ? (midpt + 1) : midpt
    root = Node.new(array[midpt], @chain[array[midpt]])
    root.left = build_tree(array.first(midpt), 0, (midpt - 1))
    root.right = build_tree(array.last(last), (midpt + 1), (array.length - 1))
    root
  end

  def insert(value, ind, root = @root)
    root.left = Node.new(value, ind) if root.left.nil? && value < root.value
    root.right = Node.new(value, ind) if root.right.nil? && value > root.value
    insert(value, ind, root.left) if value < root.value
    insert(value, ind, root.right) if value > root.value
  end

  def find(value, root = @root)
    return root if root.value == value

    if value > root.value && !root.right.nil?
      find(value, root.right)
    elsif value < root.value && !root.left.nil?
      find(value, root.left)
    else
      nil
    end
  end
end
