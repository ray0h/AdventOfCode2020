manifest = File.open('5-input.txt').read.split("\n")

def split(dir)
  row = dir.chars.first(7)
  col = dir.chars.last(3)
  [row, col]
end

def find(dirs, letter, arr)
  line = arr
  dirs.each do |dir|
    split = line.length / 2
    line = dir == letter ? line.first(split) : line.last(split)
  end
  line.first
end

# Part 1 - find the max id off the passenger list
ids = manifest.map do |passenger|
  row_dir, col_dir = split(passenger)
  row = find(row_dir, 'F', (0..127).to_a)
  col = find(col_dir, 'L', (0..7).to_a)
  id = row * 8 + col
  id
end
p ids.max

# Part 2 - find your seat id (not in first/last row)
possibles = (ids.min..ids.max).to_a
p possibles - ids
