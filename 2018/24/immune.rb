class Group
  attr_accessor :units, :hp, :immunities, :weaknesses, :damage, :attack, :initiative, :enemies, :type, :id

  def initialize(data, type, id, boost)
    @id = id
    @type = type
    @units = /(\d+) units/.match(data)[1].to_i
    @hp = /each with (\d+) hit points/.match(data)[1].to_i
    @immunities, @weaknesses = parse_modifiers(data)
    @damage, @attack = /attack that does (\d+) (\w+) damage/.match(data).captures
    @damage = @damage.to_i + boost
    @initiative = /at initiative (\d+)/.match(data)[1].to_i
  end

  def to_s(extended = false)
    if extended
      "#{initiative} #{type} #{id} - #{units} x #{hp} - #{damage} #{attack} - +#{immunities.join(',')} -#{weaknesses.join('`')}"
    else
      "#{type} #{id}"
    end
  end

  def alive?
    units > 0
  end

  def effective_power
    units * damage
  end

  def target_order
    [-effective_power, -initiative]
  end

  def attack_order
    -initiative
  end

  def attack!(enemy)
    damage = damage_to(enemy)
    units_killed = damage / enemy.hp
    units_killed = enemy.units if enemy.units < units_killed
    enemy.units -= units_killed
    [damage, units_killed]
  end

  def select_target(targeted)
    targetable = enemies.select(&:alive?) - targeted
    max_damage = targetable.map { |group| damage_to(group) }.max
    return nil if max_damage == 0
    targets = targetable.select {|group| damage_to(group) == max_damage }
    targets.sort_by(&:target_order).first
  end

  def damage_to(group)
    return 0 if group.immune_to?(attack)
    damage = effective_power
    damage *= 2 if group.weak_to?(attack)
    damage
  end

  def immune_to?(attack)
    immunities.include?(attack)
  end

  def weak_to?(attack)
    weaknesses.include?(attack)
  end

  def parse_modifiers(data)
    modifiers = /\([^)]+\)/.match(data)
    return [[], []] unless modifiers
    modifiers = modifiers[0]

    immunities = []
    weaknesses = []

    if modifiers =~ /immune/
      immunities = /immune to ([^;)]+)/.match(data)[1].split(',').map(&:strip)
    end
    if modifiers =~ /weak to/
      weaknesses = /weak to ([^;)]+)/.match(data)[1].split(',').map(&:strip)
    end

    [immunities, weaknesses]
  end
end

def take_groups(input, type, boost)
  groups = []
  id = 1
  while input.any?
    line = input.shift
    next if line =~ /Immune System/ || line =~ /Infection/
    return groups if line.empty?
    groups << Group.new(line, type, id, boost)
    id += 1
  end
  groups
end

def army_summary(army)
  army.map do |group|
    "#{group} contains #{group.units} units @ #{group.damage}"
  end
end

def fight!(immune, infection)
  all = immune + infection
  rounds = 0

  while immune.any?(&:alive?) && infection.any?(&:alive?)
    targets = {}

    [*immune, *infection].sort_by(&:target_order).each do |group|
      next unless group.alive?
      to_attack = group.select_target(targets.values.compact)
      if to_attack
        targets[group] = to_attack
        #puts "#{group} will attack #{to_attack}"
      end
    end

    [*immune, *infection].sort_by(&:attack_order).each do |group|
      next unless group.alive?
      target = targets[group]
      next unless target
      damage, killed = group.attack!(target)
      #puts "#{group} does #{damage} to #{target}, killing #{killed}"
    end
    print "\t#{rounds}: #{all.map(&:units).inject(:+)}\r"
    rounds += 1
    break if rounds > ARGV[1].to_i

    #puts "Immune System:"
    #puts army_summary(immune)
    #puts "Infection:"
    #puts army_summary(infection)
    #puts
  end
end

def result(groups)
  groups.map do |group|
    group.units if group.alive?
  end.compact.inject(:+)
end

boost = 0
while true
  input = File.readlines(ARGV[0]).each(&:strip!)
  immune = take_groups(input, :immune, boost)
  infection = take_groups(input, :infection, 0)

  #puts "Immune System:"
  #puts army_summary(immune)
  #puts "Infection:"
  #puts army_summary(infection)
  #puts

  immune.each { |g| g.enemies = infection }
  infection.each { |g| g.enemies = immune }

  fight!(immune, infection)

  winner = infection.any?(&:alive?) ? infection : immune
  puts "Boost #{boost}: #{winner.first.type} #{result(winner)}"

  break if winner.first.type == :immune
  boost += 1
end
