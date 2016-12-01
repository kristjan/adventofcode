data = File.readlines(ARGV[0])
count_calories = !!ARGV[1]

class Ingredient
  FORMAT = /^(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/
  PROPERTIES = %i[capacity durability flavor texture calories]

  attr_reader :name, *PROPERTIES

  def initialize(description)
    @name, @capacity, @durability, @flavor, @texture, @calories =
      FORMAT.match(description).captures
    PROPERTIES.each do |name|
      val = instance_variable_get "@#{name}"
      instance_variable_set "@#{name}", val.to_i
    end
  end

  def to_s
    description = PROPERTIES.map do |name|
      "#{name} #{send(name)}"
    end
    "#{name}: #{description.join(', ')}"
  end
end

def sum(recipe, property)
  recipe.map do |ingredient, quantity|
    ingredient.send(property) * quantity
  end.inject(:+)
end

def calories(recipe)
  sum(recipe, :calories)
end

def score(recipe)
  (Ingredient::PROPERTIES - [:calories]).map do |property|
    contribution = sum(recipe, property)
    contribution < 0 ? 0 : contribution
  end.inject(:*)
end

ingredients = data.map { |line| Ingredient.new(line) }

best = 0
best_recipe = nil
(1...100).each do |i|
  (1...100).each do |j|
    (1...100).each do |k|
      (1...100).each do |l|
        next unless i + j + k + l == 100
        recipe = Hash[ingredients.zip([i, j, k, l])]
        next if count_calories && calories(recipe) != 500
        current = score(recipe)
        if current > best
          best = current
          best_recipe = recipe
        end
      end
    end
  end
end

puts best_recipe
puts best
