arr = [0, 1,2,3, 4, 'a']
mapped = arr.map.with_index do |el, ind|
  if el.is_a?(String)
    'na'
  elsif el.even?
    'e'
  elsif el.odd?
    'o'
  end
end

p arr
p mapped