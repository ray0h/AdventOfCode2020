require 'pry'

class Bureaucrat
  attr_accessor :hash
  def initialize(rules)
    @bags = id_colors(rules)
    @hash = hashify(@bags)
  end

  private

  def id_colors(rules)
    rules
      .map { |rule| rule.split(/ bags contain | bag..?/) }
      .map do |bag|
        bag.map.with_index do |color, ind|
          if ind.zero? # outer bag
            color
          elsif color == 'no other'
            ['no other']
          else
            # separate number of bags from color
            color.strip.split(' ', 2)
          end
        end
      end
  end

  # turn rules into graph
  def hashify(bags)
    hash = {}
    if bags.first.first.match?(/\d+|no other/)
      bags.each { |set| hash[set.last] = set.last == 'no other' ? 0 : set.first.to_i }
    else
      bags.each { |list| hash[list.first] = hashify(list.slice(1..-1)) }
    end
    hash
  end
end

class Accountant
  def initialize(hash)
    @hash = hash
  end

  def count_inside(color)
    return 0 if color == 'no other'

    colors = @hash[color].keys
    counts = @hash[color].values
    # add number of bags at current level + bags at deeper levels * number of that color
    total = counts.reduce(&:+) + colors.map.with_index { |ins, ind| count_inside(ins) * counts[ind] }.reduce(&:+)
    total
  end

  def count_possibles(target) # target color
    # @hash.keys = array of all possible bag colors
    @hash
      .keys
      .map { |color| find_bag(color, target) }
      .reject(&:zero?).length
  end

  private

  def find_bag(color, target)
    inside = @hash[color].keys
    return 0 if inside.include?('no other')
    return 1 if inside.include?(target) # target color

    inside.map { |ins_color| find_bag(ins_color, target) }.reduce(&:+)
  end
end

rules = File.open('7-input.txt').read.split("\n")

bureaucrat = Bureaucrat.new(rules)
counter = Accountant.new(bureaucrat.hash)

p counter.count_possibles('shiny gold')
p counter.count_inside('shiny gold')
