manifest = File.open('5-input.txt').read.split("\n")

def split(dir)
  row = dir.chars.first(7)
  col = dir.chars.last(3)
  [row, col]
end

def find_row(row_dir)
  rows = (0..127).to_a
  row_dir.each do |dir|
    split = rows.length / 2
    rows = dir == 'F' ? rows.first(split) : rows.last(split)
  end
  rows.first
end

def find_col(col_dir)
  cols = (0..7).to_a
  col_dir.each do |dir|
    split = cols.length / 2
    cols = dir == 'L' ? cols.first(split) : cols.last(split)
  end
  cols.first
end

# Part 1 - find the max id off the passenger list
max = 0
manifest.each do |passenger|
  row_dir, col_dir = split(passenger)
  row = find_row(row_dir)
  col = find_col(col_dir)
  id = row * 8 + col
  max = id if id > max
end
p max

# Part 2 - find your seat id (not in first/last row)

all_seats = []
(1..126).to_a.each do |row|
  (0..7).to_a.each do |col|
    all_seats.push(row * 8 + col)
  end
end

ids = manifest.map do |passenger|
  row_dir, col_dir = split(passenger)
  row = find_row(row_dir)
  col = find_col(col_dir)
  id = row * 8 + col
  id
end

possibles = all_seats - ids
seat = possibles.reject do |el|
  possibles.include?(el + 1) || possibles.include?(el - 1)
end

p seat.first