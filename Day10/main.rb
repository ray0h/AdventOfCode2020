adapters = File.open('10-input.txt').read.split("\n").map(&:to_i)

# sort the adapter list
jolt_chain = adapters.clone.sort
# 0 'jolts' is the joltage from the dash
jolt_chain.unshift(0)
# calc the deltas between each adapter (last adapter automatically jumps 3 to get max jolts to device)
deltas = jolt_chain.map.with_index { |el, ind| ind == jolt_chain.length - 1 ? 3 : jolt_chain[ind + 1] - el }
# total number of delta one/delta three jolts
ones = deltas.count(1)
threes = deltas.count(3)

# Pt 1 find the product of the total number of 1 jolt, 3 jolt deltas
# p jolt_chain
# p deltas
p ones * threes

# Pt 2 find all combinations of adapters that can adapt the joltage from the dash to device
# jolt gaps of 3 must remain so the only combinations come from the adapters with a jolt gap of 1.
# the more of these consecutive 1 jolt gaps/deltas, the more possible combinations there are for a 
# given set of consecutive 1 jolt gaps.
# e.g.
# for a set of one 1 jolt gap (1, 2), the combo is 1 (that adapter must be there).
# for a set of two 1 jolt gaps (1, 2, 3), the combos are 2 (all adapters or the one in the middle can be omitted)
# for a set of three 1 jolt gaps (1, 2, 3, 4), the combos are 4
# could not figure out the pattern for all the possible gaps, but the consecutive gaps
# maxed out at 4 for this problem, so was easily able to work the combinations out by hand.
# total number of combos would be the product of the combos from the individual sets of consecutive 1 jolt gaps
# ..still wondering about the pattern for higher numbers of consecutive 1 jolt gaps.

# map out how many consecutive 1 jolt gap sets there are
def consec_ones(deltas)
  co_arr = []
  count = 0
  deltas.each do |delta|
    co_arr.push(count) if delta == 3
    count = delta == 3 ? 0 : count + 1
  end
  co_arr.reject(&:zero?)
end

# combos based on number of consecutive 1 jolt deltas (1 = 1, 2 = 2, 3 = 4, etc.)
poss_combos = [0, 1, 2, 4, 7, 13, 24, 42]
combos = consec_ones(deltas).map{ |el| poss_combos[el] }.reduce(&:*)
p combos
