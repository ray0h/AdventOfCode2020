require 'pry'

class Life3D
  def initialize(layer)
    @start = layer
    @grid = [layer]
    @x_width = layer[0].length
    @y_length = layer.length
    @z_height = @grid.length
    @z_origin = 0
  end

  def count_active
    p @grid.flatten.count('#')
  end

  def print_grid
    @z_height.times do |i|
      puts "z=#{i - @z_origin}"
      @y_length.times do |j|
        puts @grid[i][j].join('')
      end
      puts
    end
  end

  def cycle
    # eval if need to expand grid
    add_edges
    add_layers
    # create temp grid to seq capture new state
    next_grid = Array.new(@z_height) { Array.new(@y_length) { Array.new(@x_width) { '.' } } }
    @z_height.times do |i|
      @y_length.times do |j|
        @x_width.times { |k| next_grid[i][j][k] = eval_spot([i, j, k]) }
      end
    end
    @grid = next_grid
  end

  private

  def initialize_grid
    add_edges if pushing_2d_boundary?(@start)
    add_layers
  end

  # determine whether pair of coordinates is at the edges of a layer
  def edge?(coord)
    coord[0].zero? || coord[1].zero? || coord[0] == @y_length || coord[1] == @x_width
  end

  # determine whether edges are filled with an active cube and need to be expanded for calculations
  def pushing_2d_boundary?
    @z_height.times do |i|
      @y_length.times do |j|
        @x_width.times do |k|
          # binding.pry if layer[j][k].nil?
          return true if @grid[i][j][k] == '#' && edge?([j, k])
        end
      end
    end
  end

  # helper for add_edges
  def add_surrounding(arr, addn)
    arr.push(addn)
    arr.unshift(addn)
  end

  def add_edges
    return unless pushing_2d_boundary?

    @grid.each do |layer|
      # add space ('.') before/after each row
      layer.each { |row| add_surrounding(row, '.') }

      # add empty row to each layer
      empty_row = Array.new(@x_width + 2) { '.' }
      add_surrounding(layer, empty_row)
    end
    @x_width += 2
    @y_length += 2
  end

  # 'top' is adding to the end of z-array
  def add_top_layer
    new_layer = Array.new(@y_length) { Array.new(@x_width) { '.' } }
    @grid.push(new_layer)
    @z_height += 1
  end

  # 'bottom' is adding to the beginning of the z-array
  def add_bottom_layer
    new_layer = Array.new(@y_length) { Array.new(@x_width) { '.' } }
    @grid.unshift(new_layer)
    @z_origin += 1
    @z_height += 1
  end

  # conditionally add layers on top or bottom if signs of active cube(s) at current edge layers
  def add_layers
    bottom_layer = @grid.first
    top_layer = @grid.last
    add_top_layer if top_layer.flatten.count('#').positive?
    add_bottom_layer if bottom_layer.flatten.count('#').positive?
  end

  def in_current_bounds?(spot)
    (0..@z_height - 1).to_a.include?(spot[0]) &&
      (0..@y_length - 1).to_a.include?(spot[1]) &&
      (0..@x_width - 1).to_a.include?(spot[2])
  end

  # returns the number of active squares surrounding a given coordinate
  def neighbors(spot)
    neighbors = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        (-1..1).each do |k|
          disp = [spot[0] + i, spot[1] + j, spot[2] + k]
          next if spot == disp || !in_current_bounds?(disp)

          neighbors += 1 if active?(disp)
        end
      end
    end
    neighbors
  end

  # helper for eval_spot
  def active?(spot)
    @grid[spot[0]][spot[1]][spot[2]] == '#'
  end

  # returns what should fill the spot after cycle
  def eval_spot(spot)
    return [2, 3].include?(neighbors(spot)) ? '#' : '.' if active?(spot)

    # else spot is inactive
    neighbors(spot) == 3 ? '#' : '.'
  end
end
