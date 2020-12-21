require 'pry'

class Analyzer
  attr_accessor :monster
  def initialize(pieced)
    @pieced = pieced
    @length = @pieced.length
    trim_pieces
    @piece_length = @pieced[0][0].length
    @picture = join
    @pic_length = @picture.length

    @monster = File.read('monster.txt').split("\n").map(&:chars)
    @m_height = @monster.length
    @m_length = @monster[0].length
    @m_count = @monster.flatten.count('#')
  end

  def id_monsters
    original = @picture.clone
    max = 0
    # rotate through original and flipped orientation
    [original, flip(original)].each do |picture|
      4.times do
        count = 0
        picture = rotate_grid(picture)
        (@picture.length - @m_height).times do |i|
          (@picture.length - @m_length).times do |j|
            section = section([i, j], picture)
            count += 1 if match?(section)
          end
        end
        max = count if count > max
      end
    end
    p max
    p @m_count
    p count_visible
    p count_visible - max * @m_count
  end

  def section(coord, picture)
    section = []
    @m_height.times do |i|
      line = []
      @m_length.times do |j|
        line.push(picture[coord[0] + i][coord[1] + j])
      end
      section.push(line)
    end
    section
  end

  def match?(section)
    @m_height.times do |i|
      @m_length.times do |j|
        next if @monster[i][j] == ' '
        return false if @monster[i][j] != section[i][j]
      end
    end
    true
  end

  def count_visible
    @picture.flatten.count('#')
  end

  def trim_pieces
    @length.times do |i|
      @length.times do |j|
        piece = @pieced[i][j]
        piece.shift
        piece.pop
        piece.each do |row|
          row.shift
          row.pop
        end
      end
    end
  end

  def join
    picture = []
    @length.times do |x|
      @piece_length.times do |i|
        line = []
        @length.times { |y| line += @pieced[x][y][i] }
        picture.push(line)
      end
    end
    picture
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

  def print(picture)
    picture.length.times { |i| p picture[i].join }
  end
end
