ans_list = File.open('6-input.txt').readlines

class Analyzer

  def count_answers(list)
    list.each_with_index do |ans, ind|
      @group.push(ans.chomp.chars) if ans != "\n"
      yield if ans == "\n" || ind == list.length - 1
    end
    @count
  end

  def count_group_any(list)
    @count = 0
    @group = []
    count_answers(list) do
      @count += @group.flatten.uniq.length
      @group = []
    end
  end

  def count_group_all(list)
    @count = 0
    @group = []
    count_answers(list) do
      yeses = @group.flatten.uniq
      yeses.each { |question| @count += 1 if @group.flatten.count(question) == @group.length }
      @group = []
    end
  end
end

counter = Analyzer.new
# Pt 1 - count 'yes' answer to ANY of particular question in given group
p counter.count_group_any(ans_list)

# Pt 2 - count 'yes' answer to ALL of particular question in given group
p counter.count_group_all(ans_list)
