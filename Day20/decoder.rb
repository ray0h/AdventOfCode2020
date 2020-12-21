require 'pry'

# Decoder will take input and fit together pieces
class Decoder
  attr_accessor :picture
  def initialize(file)
    @file = file
    @squares = define_squares(@file)
    @pic_length = (@squares.keys.length**0.5).to_i
    @borders = all_borders
    @picture = Array.new(@pic_length) { Array.new(@pic_length) { nil } }

    @piece_ids = @squares.keys
    @pieces = @piece_ids.map { |piece| @squares[piece]['grid'] }

    @corner_ids = find_corners
    @corner_pieces = @corner_ids.map { |piece| @squares[piece]['grid'] }
  end

  # Part 1 Soln
  def find_corners
    corners = []
    @squares.keys.each do |id|
      set = @squares[id]['borders']
      # find borders in the set that match with another square
      matches = set.map { |bord| @borders.count(bord) == 2 }.count(true)
      corners.push(id) if matches == 2
    end
    corners
  end

  # For Part 2
  def fit_pieces
    nucleate
    fill_top_row
    fill_out_rows
  end

  def nucleate
    coord = [0, 0] # spot in picture grid to fill
    original = @corner_pieces.shift # grab any corner piece to start the fit
    f_piece = flip(original)

    [original, f_piece].each do |piece|
      try_fit(piece, coord) { |p, borders|
        place_piece(p, coord) if [1, 2].map { |i| @borders.count(borders[i]) == 2 }.all?(true)
      }
    end
    @pieces.delete(original) # remove piece from 'pile'
  end

  def fill_top_row
    (1..@pic_length - 1).each do |i|
      coord = [0, i]
      @pieces.each do |original| # shuffle through pieces
        [original, flip(original)].each do |piece| # try piece originally and flipped
          try_fit(piece, coord) { |p, borders| # rotate the piece to see what edge matches
            last_border = grab_borders(@picture[0][i - 1])
            if last_border[1] == borders[3] # edges match...
              place_piece(p, coord)
              @pieces.delete(original) # remove piece from set once placed
            end
          }
        end
      end
    end
  end

  def fill_out_rows
    (1..@pic_length - 1).each do |i|
      @pic_length.times do |j|
        coord = [i, j]
        @pieces.each do |original| # shuffle through pieces
          [original, flip(original)].each do |piece| # try piece originally and flipped
            try_fit(piece, coord) { |p, borders| # rotate the piece to see what edge matches
              last_border = grab_borders(@picture[i - 1][j])
              if last_border[2] == borders[0] # edges match...
                place_piece(p, coord)
                @pieces.delete(original) # remove piece from set once placed
              end
            }
          end
        end
      end
    end
  end

  def try_fit(piece, coord)
    return unless @picture[coord[0]][coord[1]].nil?

    4.times do
      next unless @picture[coord[0]][coord[1]].nil?

      piece = rotate_grid(piece)
      borders = grab_borders(piece)
      yield(piece, borders)
    end
  end

  def place_piece(piece, coord)
    @picture[coord[0]][coord[1]] = piece
  end

  # defines all possible borders
  def all_borders
    borders = []
    @squares.values.each do |value|
      value['borders'].each do |border|
        borders.push(border)
        borders.push(border.reverse)
      end
    end
    borders
  end

  # initialize squares from file
  # includes grid and borders
  def define_squares(file)
    squares = {}

    file.each do |lines|
      lines = lines.split("\n")
      id = lines.shift.match(/\d+/)[0].to_i
      grid = []
      lines.each { |line| grid.push(line.chars) }
      squares[id] = { 'grid' => grid, 'borders' => grab_borders(grid) }
    end
    squares
  end

  # find borders of grid
  def grab_borders(grid)
    length = grid.length
    edge1 = []
    edge2 = []
    length.times do |i|
      edge1.push(grid[i][length - 1])
      edge2.push(grid[i][0])
    end
    # borders are N, E, S, W
    [grid[0], edge1, grid[length - 1], edge2]
  end

  # function that rotates grid clockwise
  def rotate_grid(grid)
    length = grid.length
    new_grid = Array.new(length) { Array.new(length) }
    length.times do |i|
      length.times do |j|
        new_grid[i][j] = grid[length - 1 - j][i]
      end
    end
    new_grid
  end

  def flip(grid)
    grid.map(&:reverse)
  end

  def print(grid)
    grid.length.times { |i| p grid[i].join }
  end
end
