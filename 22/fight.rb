SPELL_COSTS = {
  magic_missile: 53,
  drain:         73,
  shield:        113,
  poison:        173,
  recharge:      229
}

@min = Float::INFINITY

Boss = Struct.new(:health, :damage)
boss = Boss.new(*File.readlines(ARGV[0]).map { |l| l.split(':').last.to_i })

Player = Struct.new(:health, :mana)
player = Player.new(ARGV[1].to_i, ARGV[2].to_i)

HARD = !!ARGV[3]

def magic_missile(player, boss, active_effects, mana_used)
  return if player.mana < SPELL_COSTS[:magic_missile]
  player.mana -= SPELL_COSTS[:magic_missile]
  boss.health -= 4
  boss_turn(player, boss, active_effects, mana_used + SPELL_COSTS[:magic_missile])
end

def drain(player, boss, active_effects, mana_used)
  return if player.mana < SPELL_COSTS[:drain]
  player.mana -= SPELL_COSTS[:drain]
  player.health += 2
  boss.health -= 2
  boss_turn(player, boss, active_effects, mana_used + SPELL_COSTS[:drain])
end

def shield(player, boss, active_effects, mana_used)
  return if player.mana < SPELL_COSTS[:shield]
  return if active_effects[:shield] > 0
  player.mana -= SPELL_COSTS[:shield]
  active_effects[:shield] = 6
  boss_turn(player, boss, active_effects, mana_used + SPELL_COSTS[:shield])
end

def poison(player, boss, active_effects, mana_used)
  return if player.mana < SPELL_COSTS[:poison]
  return if active_effects[:poison] > 0
  player.mana -= SPELL_COSTS[:poison]
  active_effects[:poison] = 6
  boss_turn(player, boss, active_effects, mana_used + SPELL_COSTS[:poison])
end

def recharge(player, boss, active_effects, mana_used)
  return if player.mana < SPELL_COSTS[:recharge]
  return if active_effects[:recharge] > 0
  player.mana -= SPELL_COSTS[:recharge]
  active_effects[:recharge] = 5
  boss_turn(player, boss, active_effects, mana_used + SPELL_COSTS[:recharge])
end

def boss_turn(player, boss, active_effects, mana_used)
  effects(player, boss, active_effects)

  if boss.health <= 0
    if mana_used < @min
      @min = mana_used
      puts "Boss is dead. New min #{mana_used}."
    end
  end

  shield = active_effects[:shield] > 0 ? 7 : 0
  damage = boss.damage - shield

  player.health -= damage
  return if player.health <= 0
  fight(player, boss, active_effects, mana_used)
end

def effects(player, boss, active_effects)
  if active_effects[:poison] > 0
    boss.health -= 3
    active_effects[:poison] -= 1
  end

  if active_effects[:recharge] > 0
    player.mana += 101
    active_effects[:recharge] -= 1
  end

  if active_effects[:shield] > 0
    active_effects[:shield] -= 1
  end
end

def fight(player, boss, active_effects, mana_used)
  player.health -= 1 if HARD
  return if player.health <= 0

  effects(player, boss, active_effects)

  if boss.health <= 0
    if mana_used < @min
      @min = mana_used
      puts "Boss is dead. New min #{mana_used}."
    end
  end

  return if mana_used >= @min

  SPELL_COSTS.each do |spell, cost|
    send(spell, player.dup, boss.dup, active_effects.dup, mana_used)
  end
end

fight(player, boss, Hash.new(0), 0)
