require 'minitest/autorun'
require_relative 'calculator'

# validate problem examples
class StdCalcTest < Minitest::Test
  def setup
    ex1 = '1 + 2 * 3 + 4 * 5 + 6'
    ex2 = '1 + (2 * 3) + (4 * (5 + 6))'
    ex3 = '2 * 3 + (4 * 5)'
    ex4 = '5 + (8 * 3 + 9 + 3 * 4 * 3)'
    ex5 = '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'
    ex6 = '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
    @eqns = [ex1, ex2, ex3, ex4, ex5, ex6].map do |str|
      str.chars.reject { |el| el == ' ' }.map { |el| el.match?(/\d+/) ? el.to_i : el }
    end
    @calc = Calculator.new(@eqns)
  end

  def test_string_deconstruction
    assert_equal [1, '+', 2, '*', 3, '+', 4, '*', 5, '+', 6], @eqns[0]
  end

  def test_std_calculator
    assert_equal 71, @calc.std_calc(@eqns[0])
    assert_equal 51, @calc.std_calc(@eqns[1])
    assert_equal 26, @calc.std_calc(@eqns[2])
    assert_equal 437, @calc.std_calc(@eqns[3])
    assert_equal 12240, @calc.std_calc(@eqns[4])
    assert_equal 13632, @calc.std_calc(@eqns[5])
  end

  def test_ap_calculator
    assert_equal 231, @calc.ap_calc(@eqns[0])
    assert_equal 51, @calc.ap_calc(@eqns[1])
    assert_equal 46, @calc.ap_calc(@eqns[2])
    assert_equal 1445, @calc.ap_calc(@eqns[3])
    assert_equal 669060, @calc.ap_calc(@eqns[4])
    assert_equal 23340, @calc.ap_calc(@eqns[5])
  end
end
