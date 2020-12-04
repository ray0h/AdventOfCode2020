require 'pry'

list = File.open('4-input.txt').readlines
# list can be multiple lines but single passport data are separated by blank lines.
# organize data into single string of passport params
collated = []
current = {}
list.length.times do |i|
  if list[i] == list.last
    list[i].chomp.split(' ').map { |param| param.split(':') }.map { |hashable| current[hashable[0]] = hashable[1] }
    collated.push(current)
  elsif list[i] == "\n"
    collated.push(current)
    current = {}
  else
    list[i].chomp.split(' ').map { |param| param.split(':') }.map { |hashable| current[hashable[0]] = hashable[1] }
  end
end

params = %w[byr iyr eyr hgt hcl ecl pid cid]
# byr - birth year
# iyr - passport issue year
# eyr - passport exp year
# hgt - person height (cm or in)
# hcl - person hair color (hex field)
# ecl - person eye color (list of values)
# pid - passport id
# cid - country id

hacked_params = params - ['cid']

# Part 1
# search passport data strings to see which have all params in 'hacked params array list'
has_fields = []
collated.each do |fields|
  check = hacked_params.map { |param| fields.keys.include?(param) }
  has_fields.push(fields) if check.all?(true)
end
p "no passports on initial list: #{collated.length}"
p "no passports with valid fields: #{has_fields.length}"

# Part 2
# now must validate the fields to make sure they are in specified ranges or have valid values

valid_ppt = 0
has_fields.each do |ppt|
  byr_check = (1920..2003).include?(ppt['byr'].to_i)
  iyr_check = (2010..2020).include?(ppt['iyr'].to_i)
  eyr_check = (2020..2030).include?(ppt['eyr'].to_i)

  # binding.pry
  if ppt['hgt'].match?(/cm|in/)
    hgt_unit = ppt['hgt'].match(/cm|in/)[0]
    hgt_val = ppt['hgt'].match(/\d+/)[0].to_i
    hgt_check = (150..193).include?(hgt_val) if hgt_unit == 'cm'
    hgt_check = (50..76).include?(hgt_val) if hgt_unit == 'in'
  else
    hgt_check = false
  end

  hcl_check = ppt['hcl'].match?(/^#[a-f0-9]{6}$/)
  ecl_check = %w[amb blu brn gry grn hzl oth].include?(ppt['ecl'])
  pid_check = ppt['pid'].match?(/^[0-9]{9}$/)

  valid_ppt += 1 if [byr_check, iyr_check, eyr_check, hgt_check, hcl_check, ecl_check, pid_check].all?(true)
  # binding.pry
end
p "total number valid passports: #{valid_ppt}"
