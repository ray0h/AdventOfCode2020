require 'pry'

class Analyzer
  attr_accessor :fields, :tickets, :my_ticket, :field_pos
  def initialize(data)
    @data = data
    @field_lines = find_field_lines(@data)
    @fields = find_fields(@field_lines)
    @f_ranges = find_valid_numbers(@field_lines)
    @my_ticket = find_my_ticket(@data)
    @tickets = find_ticket_lines(@data)
    @valid_tix = sort_tickets(@tickets)
    @positional_values = find_pos_vals(@valid_tix)
    @field_pos = {}
    id_fields
  end

  # Part 1 Soln
  def scan_error_rate
    invalid_vals = []
    @tickets.each do |ticket|
      digits = ticket_values(ticket)
      invalids = digits - (digits & @f_ranges.flatten)
      invalid_vals += invalids
    end
    # p invalid_vals
    p invalid_vals.reduce(&:+)
  end

  # Part 2 Soln
  def mult_departure_fields
    # find fields containing 'departure'
    deps = @field_pos.keys.select { |k| k.match?(/departure/) }
    # find corresponding indices of the fields
    locs = deps.map { |d| @field_pos[d] }
    # get values from 'my ticket'
    my_tix_vals = ticket_values(@my_ticket)
    # get the product of 'departure' fields from 'my ticket'
    p locs.map { |l| my_tix_vals[l] }.reduce(&:*)
  end

  private

  def in_range?(subset, range)
    subset == (subset & range)
  end

  def find_field_lines(data)
    data.select { |d| d.match?(/[0-9]/) && d.match?(/[a-z]/) }
  end

  def find_fields(field_lines)
    field_lines.map { |f| f.split(':')[0] }
  end

  def find_ticket_lines(data)
    data.select { |d| d.match?(/\d+/) && !d.match?(/[a-z]/) }
  end

  def find_my_ticket(data)
    data.each_with_index do |el, ind|
      return data[ind + 1] if el.match?(/your ticket:/)
    end
  end

  # returns array of valid range numbers per the field range input
  def find_valid_numbers(fields)
    bounds = fields.map { |line| line.scan(/\d+/).map(&:to_i) }
    valid_numbers = []
    bounds.each do |set|
      pair = []
      (0..set.length - 1).step(2) { |ind| pair += (set[ind]..set[ind + 1]).to_a }
      valid_numbers << pair
    end
    valid_numbers
  end

  def find_pos_vals(tickets)
    tickets = tickets.map { |ticket| ticket_values(ticket) }
    pos_vals = (0..tickets[0].length - 1).to_a
    # binding.pry
    pos_vals.map { |ind| tickets.map { |t| t[ind] }.uniq.sort }
  end

  # select tickets whose field values are valid (within field value ranges)
  def sort_tickets(tickets)
    tickets.select { |ticket| in_range?(ticket_values(ticket).uniq, @f_ranges.flatten.uniq) }
  end

  # format and return array of field values from a given ticket string
  def ticket_values(ticket)
    ticket.split(',').map(&:to_i)
  end

  # match up field names with positional indices
  # @field_pos is the hash that defines this
  def id_fields
    until @field_pos.keys.length == @fields.length
      # iterate through each field range
      @f_ranges.each_with_index do |f_r, f_ind|
        possibles = []
        # see if positional values for unknown fall within the field range
        @positional_values.each_with_index do |p_v, p_ind|
          next if @field_pos.values.include?(p_ind)

          possibles.push(p_ind) if in_range?(p_v, f_r)
        end
        # assign field to position if it is the only possible combination
        @field_pos[@fields[f_ind]] = possibles[0] if possibles.length == 1
      end
    end
  end
end
