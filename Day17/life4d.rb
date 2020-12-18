require 'pry'

class Life4D
  def initialize(layer)
    @start = layer
    @hypercube = [[layer]]
    @x_dim = layer[0].length
    @y_dim = layer.length
    @z_dim = @hypercube[0].length
    @w_dim = @hypercube.length
    @z_origin = 0
    @w_origin = 0
  end

  def count_active
    p @hypercube.flatten.count('#')
  end

  def print_grid
    @w_dim.times do |h|
      @z_dim.times do |i|
        puts "w=#{h - @w_origin}, z=#{i - @z_origin}"
        @y_dim.times do |j|
          puts @hypercube[h][i][j].join('')
        end
        puts
      end
    end
  end

  def cycle
    # eval if need to expand hypercube
    add_edges
    add_layers
    add_grids
    # create temp hypercube to seq capture new state
    next_hc = Array.new(@w_dim) { Array.new(@z_dim) { Array.new(@y_dim) { Array.new(@x_dim) { '.' } } } }
    @w_dim.times do |h|
      @z_dim.times do |i|
        @y_dim.times do |j|
          @x_dim.times { |k| next_hc[h][i][j][k] = eval_spot([h, i, j, k]) }
        end
      end
    end
    @hypercube = next_hc
  end

  private

  # determine whether trio of coordinates are at the edges
  def two_d_edge?(coord)
    coord[0].zero? || coord[1].zero? || coord[0] == @y_dim || coord[1] == @x_dim
  end

  def three_d_edge?(coord)
    coord[0].zero? || coord[1].zero? || coord[2].zero? || coord[0] == @z_dim || coord[1] == @y_dim || coord[2] == @x_dim
  end

  # determine whether edges are filled with an active cube and need to be expanded for calculations
  def pushing_2d_boundary?
    @w_dim.times do |h|
      @z_dim.times do |i|
        @y_dim.times do |j|
          @x_dim.times { |k| return true if @hypercube[h][i][j][k] == '#' && two_d_edge?([j, k]) }
        end
      end
    end
  end

  def pushing_top_3d_boundary?
    @w_dim.times do |h|
      return true if @hypercube[h][@z_dim - 1].flatten.count('#').positive?
    end
  end

  def pushing_bot_3d_boundary?
    @w_dim.times do |h|
      return true if @hypercube[h][0].flatten.count('#').positive?
    end
  end

  # helper for add_edges
  def add_surrounding(arr, addn)
    arr.push(addn)
    arr.unshift(addn)
  end

  def add_edges
    return unless pushing_2d_boundary?

    @hypercube.each do |grid|
      grid.each do |layer|
        # add space ('.') before/after each row
        layer.each { |row| add_surrounding(row, '.') }

        # add empty row to each layer
        empty_row = Array.new(@x_dim + 2) { '.' }
        add_surrounding(layer, empty_row)
      end
    end
    @x_dim += 2
    @y_dim += 2
  end

  # 'top' is adding to the end of z-array
  def add_top_layers
    @hypercube.each do |grid|
      new_layer = Array.new(@y_dim) { Array.new(@x_dim) { '.' } }
      grid.push(new_layer)
    end
    @z_dim += 1
  end

  # 'bottom' is adding to the beginning of the z-array
  def add_bottom_layers
    @hypercube.each do |grid|
      new_layer = Array.new(@y_dim) { Array.new(@x_dim) { '.' } }
      grid.unshift(new_layer)
    end
    @z_origin += 1
    @z_dim += 1
  end

  # conditionally add layers on top or bottom if signs of active cube(s) at current edge layers
  def add_layers
    add_top_layers if pushing_top_3d_boundary?
    add_bottom_layers if pushing_bot_3d_boundary?
  end

  def add_grids
    new_grid = Array.new(@z_dim) { Array.new(@y_dim) { Array.new(@x_dim) { '.' } } } 
    add_surrounding(@hypercube, new_grid)
    @w_origin += 1
    @w_dim += 2
  end

  def in_current_bounds?(spot)
    (0..@w_dim - 1).to_a.include?(spot[0]) &&
      (0..@z_dim - 1).to_a.include?(spot[1]) &&
      (0..@y_dim - 1).to_a.include?(spot[2]) &&
      (0..@x_dim - 1).to_a.include?(spot[3])
  end

  # returns the number of active squares surrounding a given coordinate
  def neighbors(spot)
    neighbors = 0
    (-1..1).each do |h|
      (-1..1).each do |i|
        (-1..1).each do |j|
          (-1..1).each do |k|
            disp = [spot[0] + h, spot[1] + i, spot[2] + j, spot[3] + k]
            next if spot == disp || !in_current_bounds?(disp)

            neighbors += 1 if active?(disp)
          end
        end
      end
    end
    neighbors
  end

  # helper for eval_spot
  def active?(spot)
    @hypercube[spot[0]][spot[1]][spot[2]][spot[3]] == '#'
  end

  # returns what should fill the spot after cycle
  def eval_spot(spot)
    return [2, 3].include?(neighbors(spot)) ? '#' : '.' if active?(spot)

    # else spot is inactive
    neighbors(spot) == 3 ? '#' : '.'
  end
end
