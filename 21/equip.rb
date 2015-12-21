require 'set'

class Item
  attr_reader :name, :cost, :damage, :armor

  def initialize(line)
    @name, @cost, @damage, @armor = line.split(/\s+/)
    @cost, @damage, @armor = [@cost, @damage, @armor].map(&:to_i)
  end
end

class Loadout
  attr_reader :equipment

  def initialize(equipment)
    @equipment = equipment
  end

  def armor
    @equipment.map(&:armor).inject(:+)
  end

  def cost
    @equipment.map(&:cost).inject(:+)
  end

  def damage
    @equipment.map(&:damage).inject(:+)
  end
end

class Shop
  attr_reader :weapons, :armor, :rings

  def initialize(filename)
    data = File.readlines(filename)
      .each(&:strip!)
      .slice_when { |line| line.empty? }
      .map { |set| set.reject(&:empty?) }
      .each(&:shift)
    puts data.inspect
    @weapons, @armor, @rings = data.map do |set|
      set.map { |item| Item.new(item) }
    end
  end

  def loadouts
    return @loadouts if defined? @loadouts
    @loadouts = Set.new
    weapons.each do |weapon|
      [*armor, nil].each do |armor|
        [*rings, nil].each do |left_ring|
          [*(rings - [left_ring]), nil].each do |right_ring|
            @loadouts << Loadout.new([weapon, armor, left_ring, right_ring].compact)
          end
        end
      end
    end
    @loadouts
  end
end

class Player
  attr_reader :health, :equipment

  def initialize(equipment)
    @health, @equipment = 100, equipment
  end

  def armor
    equipment.armor
  end

  def damage
    equipment.damage
  end

  def defeats?(boss)
    attacks(self, boss) <= attacks(boss, self)
  end

  private

  def attacks(attacker, defender)
    damage_per_turn = [attacker.damage - defender.armor, 1].max
    (defender.health.to_f / damage_per_turn).ceil
  end
end

class Boss
  attr_reader :health, :damage, :armor

  def initialize(filename)
    @health, @damage, @armor =
      File.readlines(filename)
        .each(&:strip!)
        .map { |line| line.split(': ').last.to_i }
  end
end

shop = Shop.new(ARGV[0])
boss = Boss.new(ARGV[1])

loadouts = shop.loadouts.group_by do |loadout|
  Player.new(loadout).defeats?(boss)
end

puts 'Cheapest winning set:'
cheapest = loadouts[true].min_by(&:cost)
puts(
  cheapest.equipment.map(&:name).inspect,
  cheapest.cost
)

puts 'Most expensive losing set:'
expensive = loadouts[false].max_by(&:cost)
puts(
  expensive.equipment.map(&:name).inspect,
  expensive.cost
)
