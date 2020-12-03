@grid = File.open('3-input.txt').read.split("\n").map(&:chars)
@height = @grid.length
@width = @grid[0].length

def travel(y_slope, x_slope)
  x = 0
  y = 0
  trees = @grid[y][x] == '#' ? 1 : 0

  until y == @height - 1
    x += x_slope
    y += y_slope
    x -= @width if x > @width - 1
    trees += 1 if @grid[y][x] == '#'
  end
  trees
end

# Pt 1 - how many trees do you run into traveling down given grid (grid repeats to the right infinitely)
p travel(1, 3)

# Pt 2 - provide product of multiple runs with multiple slopes
slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
trees = slopes.map { |sqr| travel(sqr[1], sqr[0]) }
p trees.reduce(&:*)
