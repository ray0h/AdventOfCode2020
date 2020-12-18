require 'pry'

class Calculator
  def initialize(eqns)
    @eqns = eqns # input is an array of equations, split into individual chars
  end

  def find_std_results
    eqns = @eqns.map(&:clone)
    eqns.map { |eqn| std_calc(eqn) }
  end

  def find_ap_results
    eqns = @eqns.map(&:clone)
    eqns.map { |eqn| ap_calc(eqn) }
  end

  private

  # 'standard' parentheses first, left to right operation
  def std_calc(arr)
    return nil if arr.empty?

    until arr.empty?
      if arr.include?('(')
        eval_exp(arr, arr.index('(')) { |exp|
          std_calc(exp)
        }
      elsif arr.include?('+') || arr.include?('*')
        ind = [arr.index('+'), arr.index('*')].reject(&:nil?).min
        collapse(arr, ind)
      elsif arr.length == 1
        return arr.first
      end
    end
  end

  # (a)ddition (p)recedence calculator
  def ap_calc(arr)
    return nil if arr.empty?

    until arr.empty?
      if arr.include?('(')
        eval_exp(arr, arr.index('(')) { |exp|
          ap_calc(exp)
        }
      elsif arr.include?('+')
        collapse(arr, arr.index('+'))
      elsif arr.include?('*')
        collapse(arr, arr.index('*'))
      elsif arr.length == 1
        return arr.first
      end
    end
  end

  # calc result of an expression and replace with its result in the array
  def eval_exp(arr, ind)
    rp = find_rp(arr.slice(ind..-1)) + ind
    exp = arr.slice!(ind..rp)
    result = yield(trim(exp))
    arr.insert(ind, result)
  end

  # helper to remove '(', ')' from ends of array
  def trim(arr)
    arr.clone[1..-2]
  end

  # helper to pair the correct closing parentheses and return its index
  def find_rp(arr)
    count = 0
    arr.length.times do |ind|
      count += 1 if arr[ind] == '('
      count -= 1 if arr[ind] == ')'
      return ind if count.zero?
    end
  end

  # calc result of an operation and replace with its result in the array
  def collapse(arr, ind)
    result = compute(arr[ind - 1], arr[ind + 1], arr[ind])
    arr.slice!(ind - 1..ind + 1)
    arr.insert(ind - 1, result)
  end

  # only sums and products
  def compute(first, second, oper)
    oper == '+' ? first + second : first * second
  end
end
