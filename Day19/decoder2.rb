require 'pry'

class Decoder
  attr_accessor :rules
  def initialize(file)
    @file = file
    @rules = @file.select { |el| el.match?(/^\d+:/) }
    @messages = @file - @rules
    hashify
  end

  def hashify
    @hash = {}
    @rules.each do |rule|
      key, value = rule.split(': ')
      value = value.match?(/[a-z]/) ? [value.match(/[a-z]/)[0]] : value.split(' ')
      @hash[key.to_i] = value
    end
    @rules = @hash
  end

  def solve_pt1
    fill_in
    possibles = @rules[0][0]
    p (@messages & possibles).length
  end

  def solve_pt2
    # modified loop rules
    # @rules[8] = 42 | 42 8
    # @rules[11] = 42 31 | 42 11 31
    # @rules[0] = 8 11

    # doing it manually
    # can have as many rule 42s in a row followed by a series of rule 31s.
    fill_in

    length42 = @rules[42].map(&:length).uniq.first
    length31 = @rules[31].map(&:length).uniq.first
    matches = 0
    # binding.pry
    @messages.each do |message|
      use42 = true
      start31 = nil
      i = 0
      # eval first substring
      substr = message.slice(i..(i + length42 - 1))
      next if i.zero? && !@rules[42].include?(substr)

      i += length42
      while i < message.length
        substr1 = message.slice(i..(i + length42 - 1))
        substr2 = message.slice(i..(i + length31 - 1))
        # binding.pry if message == "aaaabbaaaabbaaa"

        if @rules[42].include?(substr1) && use42 == true && i != message.length - length42
          i += length42
        elsif @rules[31].include?(substr2) && (start31.to_i > message.length / 2 || start31.to_i.zero?) 
          start31 ||= i
          i += length31
          use42 = false
          # binding.pry
        else
          # binding.pry
          break
        end
      end
      matches += 1 if i == message.length
      p message if i == message.length
    end
    p matches
  end

  def fill_in
    until filled?(@rules.values)
      @rules.keys.each do |i|
        next if filled?(@rules[i])

        @rules[i] = replace(@rules[i])
      end
    end
  end

  def replace(array)
    repl = array.map do |el|
      # ignore if already filled in with an array
      if el.is_a?(Array)
        el
      # replace number if replacement is fully filled
      elsif el.match?(/\d+/) && filled?(@rules[el.to_i])
        @rules[el.to_i]
      # else just leave it alone
      else
        el
      end
    end
    # repl
    filled?(repl) ? collapse(repl) : repl
  end

  def collapse(array)
    if array.include?('|') && array.length > 3
      ind = array.index('|')
      combine(array.slice(0..ind - 1)) + combine(array.slice(ind + 1..array.length))
    elsif array.include?('|')
      array.first + array.last
    elsif array.length == 2
      combine(array)
    else
      array
    end
  end

  def combine(array)
    return array if array.length == 1

    first = array.first
    last = array.last
    if first.length == 1 && last.length == 1
      [(first + last).join]
    elsif contains_array?(first) && contains_array?(last)
      arr = []
      first.length.times do |i|
        last.length.times do |j|
          arr.push first[i].product(last[j]).map(&:join)
        end
      end
      arr
    elsif contains_array?(first)
      binding.pry if first.include?('babbbrep')
      first.map { |el| el.product(last).map(&:join) }
    elsif contains_array?(last)
      last.map { |el| first.product(el).map(&:join) }
    else
      first.product(last).map(&:join)
    end
  end

  def filled?(array)
    !array.flatten.join.match?(/\d+/)
  end

  def contains_array?(array)
    array.each do |el|
      return true if el.length > 1 && el.is_a?(Array)
    end
    false
  end
end
