require 'pry'

class Classify
  attr_accessor :ingredient_list, :allergen_list, :possibles, :translated
  def initialize(lists)
    @lists = lists
    @processed_lists = process_lists(@lists)
    @allergens_list = allergens_list
    @ingredients_list = ingredients_list
    @possibles = find_possibles
    @translated = {}
  end

  # Part 1 soln
  def count_not_possibles
    nps = @ingredients_list - @possibles
    all_ingred = @processed_lists.map(&:first).flatten.select { |el| nps.include?(el) }
    p all_ingred.length
  end

  # Part 2 Soln
  def list_translated
    id_allergens
    allergens = @allergens_list.sort
    allergens.map { |a| @translated[a] }.join(',')
  end

  def id_allergens
    possibles = @possibles.clone
    until possibles.empty?
      @allergens_list.each do |allergen|
        next if @translated[allergen]

        # list of possible ingredients with allergen
        lists = @processed_lists.select { |list| list.last.include?(allergen) }.map(&:first)
        # filter against ingredients remaining on possibles list
        list = lists.reduce(&:&) & possibles
        if list.length == 1
          # associate ingredient/allergen
          @translated[allergen] = list.first 
          # remove ingredient from possibles list
          possibles.delete(list.first) 
        end
      end
    end
  end

  # seprate raw data into arrays of ingredients/allergens
  # ex of list 'mxmxvkd kfcds sqjhc nhms (contains dairy, fish)'
  def process_lists(lists)
    lists.map do |list|
      list = list.split(' (contains ')
      ingredients, allergens = list
      ingredients = ingredients.split(' ')
      allergens = allergens.split(', ')
      allergens[-1] = allergens.last.slice(0..-2)
      [ingredients, allergens]
    end
  end

  # returns array of ingredients that could be associated with an allergen
  def find_possibles
    possibles = []
    @allergens_list.each do |allergen|
      # lists of possible ingredients with allergen
      lists = @processed_lists.select { |list| list.last.include?(allergen) }.map(&:first)
      # reduce to those ingredients on all lists
      possibles += lists.reduce(&:&)
    end
    possibles.uniq
  end

  def allergens_list
    @processed_lists.map(&:last).flatten.uniq
  end

  def ingredients_list
    @processed_lists.map(&:first).flatten.uniq
  end
end
