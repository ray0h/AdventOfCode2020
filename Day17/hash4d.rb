require 'pry'

class HashLife4D
  def initialize(layer)
    @hypercube = initial_hash(layer)
  end

  def count_active
    puts @hypercube.keys.length
  end

  def print_grid
    hypercube = translate_hash
    hypercube.length.times do |h|
      hypercube[h].length.times do |i|
        puts "z=#{h}, w=#{i}"
        hypercube[h][i].length.times do |j|
          puts hypercube[h][i][j].join('')
        end
      end
      puts
    end
  end

  def translate_hash
    inverted = [[], [], [], []]
    @hypercube.keys.each do |coord|
      inverted[0].push(coord[0])
      inverted[1].push(coord[1])
      inverted[2].push(coord[2])
      inverted[3].push(coord[3])
    end
    bounds = inverted.map { |set| set.max - set.min + 1 }
    hypercube = Array.new(bounds[0]) { Array.new(bounds[1]) { Array.new(bounds[2]) { Array.new(bounds[3]) { '.' } } } }
    @hypercube.keys.each { |coord| hypercube[coord[0]][coord[1]][coord[2]][coord[3]] = '#' }
    hypercube
  end

  def cycle
    hypercube = @hypercube.dup
    next_hc = @hypercube.dup
    hypercube = add_inactives(hypercube)
    @hypercube = eval_spots(hypercube, next_hc)
  end

  def initial_hash(layer)
    hc = {}
    layer.length.times do |i|
      layer[i].length.times do |j|
        hc[[0, 0, i, j]] = '#' if layer[i][j] == '#'
      end
    end
    hc
  end

  def eval_spots(hypercube, next_hc)
    hypercube.keys.each do |coord|
      neighbors = 0
      (-1..1).each do |h|
        (-1..1).each do |i|
          (-1..1).each do |j|
            (-1..1).each do |k|
              disp = [coord[0] + h, coord[1] + i, coord[2] + j, coord[3] + k]
              next if coord == disp

              neighbors += 1 if @hypercube[disp] == '#'
            end
          end
        end
      end
      if hypercube[coord] == '#'
        next_hc.delete(coord) unless [2, 3].include?(neighbors)
      elsif neighbors == 3 # spot is empty
        next_hc[coord] = '#'
      end
    end
    next_hc
  end

  def add_inactives(hypercube)
    @hypercube.keys.each do |coord|
      (-1..1).each do |h|
        (-1..1).each do |i|
          (-1..1).each do |j|
            (-1..1).each do |k|
              disp = [coord[0] + h, coord[1] + i, coord[2] + j, coord[3] + k]
              # binding.pry
              hypercube[disp] = '.' unless hypercube[disp] == '#'
            end
          end
        end
      end
    end
    hypercube
  end
end
