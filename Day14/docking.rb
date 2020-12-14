require 'pry'

class Docking
  def initialize(filename)
    @code = File.readlines(filename, chomp: true)
    @mem = {}
    @mask = ''
  end

  def execute_part1
    reset_memory
    @code.each { |line| parse_line(line) { |address, value| decode_val(address, value) } }
    puts 'Part 1 Soln:'
    p @mem.values.reduce(&:+)
  end

  def execute_part2
    reset_memory
    @code.each { |line| parse_line(line) { |address, value| decode_addr(address, value) } }
    puts 'Part 2 Soln:'
    p @mem.values.reduce(&:+)
  end

  private

  def parse_line(line)
    line = line.split(' = ')
    if line[0] == 'mask'
      @mask = line[1]
    else
      address = line[0].match(/\d+/)[0].to_i
      value = line[1].to_i
      yield(address, value)
    end
  end

  def decode_val(address, value)
    # reverse mask and address so lowest/rightmost bits are evaluated first
    mask = @mask.reverse.chars
    # make bin(ary)_val(ue) same lenght as mask
    bin_val = value.to_s(2).reverse.chars + Array.new(36 - value.to_s(2).length) { '0' }
    @mem[address] = add_value_mask(mask, bin_val)
  end

  def add_value_mask(mask, bin_val)
    # compare each mask bit vs value bit
    masked = mask.map.with_index { |bit, index| bit == 'X' ? bin_val[index].to_i | 0 : bit }
    # return final decimal value
    masked.reverse.join('').to_i(2)
  end

  def decode_addr(address, value)
    gapped_addr = add_addr_mask(address)
    # get all combinations of 0, 1's to fill in 'X's
    perms = gaps
    perms.each do |perm|
      # sub in values for X's and assign final addresses the value
      addr = gapped_addr.gsub(/X/) { |_bit| perm.shift.to_s }
      @mem[addr.to_i(2)] = value
    end
  end

  def gaps
    gaps = @mask.count('X')
    # returns all permutations that will fill in gap of 'X's (total = 2**gaps)
    # e.g. 'XX' => [[0,0], [0,1], [1,0], [1,1]]
    [0, 1].repeated_permutation(gaps).to_a
  end

  def add_addr_mask(address)
    # reverse mask and address so lowest/rightmost bits are evaluated first
    mask = @mask.reverse.chars
    bin_addr = address.to_s(2).reverse.chars

    mask.map.with_index { |bit, ind| bit == 'X' ? bit : (bin_addr[ind].to_i | bit.to_i) }.reverse.join('')
  end

  def reset_memory
    @mem = {}
  end
end
