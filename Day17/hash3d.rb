require 'pry'

class HashLife3D
  def initialize(layer)
    @active_grid = initial_hash(layer)
  end

  def count_active
    puts @active_grid.keys.length
  end

  def print_grid
    grid = translate_hash
    grid.length.times do |i|
      puts "z=#{i}"
      grid[i].length.times do |j|
        puts grid[i][j].join('')
      end
      puts
    end
  end

  def translate_hash
    inverted = [[], [], []]
    @active_grid.keys.each do |coord|
      inverted[0].push(coord[0])
      inverted[1].push(coord[1])
      inverted[2].push(coord[2])
    end
    bounds = inverted.map { |set| set.max - set.min + 1 }
    active_grid = Array.new(bounds[0]) { Array.new(bounds[1]) { Array.new(bounds[2]) { '.' } } }
    @active_grid.keys.each { |coord| active_grid[coord[0]][coord[1]][coord[2]] = '#' }
    active_grid
  end

  def cycle
    # copy current actives hash
    grid = @active_grid.dup
    # create next grid
    next_grid = @active_grid.dup
    # add relevant inactives to grid
    grid = add_inactives(grid)
    @active_grid = eval_spots(grid, next_grid)
  end

  def initial_hash(layer)
    grid = {}
    layer.length.times do |i|
      layer[i].length.times do |j|
        grid[[0, i, j]] = '#' if layer[i][j] == '#'
      end
    end
    grid
  end

  def eval_spots(grid, next_grid)
    grid.keys.each do |coord|
      neighbors = 0
      (-1..1).each do |i|
        (-1..1).each do |j|
          (-1..1).each do |k|
            disp = [coord[0] + i, coord[1] + j, coord[2] + k]
            next if coord == disp

            neighbors += 1 if grid[disp] == '#'
          end
        end
      end
      if grid[coord] == '#'
        next_grid.delete(coord) unless [2, 3].include?(neighbors)
      elsif neighbors == 3 # spot is empty
        next_grid[coord] = '#'
      end
    end
    next_grid
  end

  def add_inactives(grid)
    @active_grid.keys.each do |coord|
      (-1..1).each do |i|
        (-1..1).each do |j|
          (-1..1).each do |k|
            disp = [coord[0] + i, coord[1] + j, coord[2] + k]
            grid[disp] = '.' unless grid[disp] == '#'
          end
        end
      end
    end
    grid
  end
end
