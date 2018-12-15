require 'set'

DEBUG = false

def debug(*args)
  puts args.inspect if DEBUG
end

class Cell
  attr_reader :cavern
  attr_accessor :row, :col

  def initialize(cavern, row, col)
    @cavern = cavern
  end

  def pos
    [row, col]
  end

  def open?
    false
  end
end

class Unit < Cell
  attr_accessor :hp
  attr_reader :power

  def initialize(cavern, row, col, power: 3)
    @cavern = cavern
    @row = row
    @col = col
    @hp = 200
    @power = power
  end

  def adjacent_enemies
    cavern.adjacent_to(pos)
      .select { |cell| enemies.include?(cell) }
      .sort_by(&:pos)
  end

  def attack!
    return unless can_attack?
    min_hp = adjacent_enemies.map(&:hp).min
    weak = adjacent_enemies.select { |e| e.hp == min_hp }
    enemy = weak.sort_by(&:pos).first

    debug pos, 'Enemies', adjacent_enemies.map(&:hp)
    debug pos, 'Attacks', enemy.pos, enemy.hp
    cavern.damage!(enemy, power)
  end

  def can_attack?
    adjacent_enemies.any?
  end

  def dead?
    hp <= 0
  end

  def move!
    targets = {}
    threatening_spaces.each { |space| targets[space] = [] }

    queue = [
      [pos] # Make it a path
    ]
    seen = Set.new
    min = Float::INFINITY

    while queue.any?
      cur = queue.shift

      loc = cur.last
      next if seen.include?(loc)
      seen << loc

      if targets.keys.include?(loc)
        targets[loc] << cur
      end

      cavern.open_neighbors(loc).each do |n|
        path = cur + [n]
        queue << path
      end
    end

    all_paths = targets.values.flatten(1)
    return if all_paths.empty?

    min = all_paths.map(&:size).min
    _target, paths = targets.to_a.sort_by(&:first).detect do |space, ps|
      ps.any? {|path| path.size == min}
    end
    new_pos = paths
      .select { |path| path.size == min }
      .map { |path| path[1] } # 0 was current position, 1 is the next step
      .sort
      .first

    cavern.move!(self, new_pos)
  end

  def threatening_spaces
    enemies.flat_map { |enemy| cavern.open_neighbors(enemy.pos) }.uniq
  end
end

class Open < Cell
  def to_s
    ?.
  end

  def open?
    true
  end
end

class Wall < Cell
  def to_s
    ?#
  end
end

class Elf < Unit
  def to_s
    ?E
  end

  def enemies
    cavern.goblins
  end
end

class Goblin < Unit
  def to_s
    ?G
  end

  def enemies
    cavern.elves
  end
end

class Cavern
  attr_accessor :terrain

  def initialize(input, elf_power: 3)
    @terrain = nil
    @elves = []
    @goblins = []
    setup(input, elf_power)
  end

  def adjacent_to(pos)
    neighbors(pos).map do |(row, col)|
      terrain[row][col]
    end
  end

  def damage!(unit, pain)
    unit.hp -= pain
    if unit.dead?
      debug unit.pos, 'dies'
      row, col = unit.pos
      terrain[row][col] = Open.new(self, row, col)
      @elves.delete(unit)
      @goblins.delete(unit)
    end
  end

  def elves
    @elves.sort_by(&:pos)
  end

  def goblins
    @goblins.sort_by(&:pos)
  end

  def units
    [*elves, *goblins].sort_by(&:pos)
  end

  def winner
    case
    when elves.size   == 0 then :goblins
    when goblins.size == 0 then :elves
    end
  end

  def display
    terrain.each do |row|
      puts row.map(&:to_s).join
    end
  end

  def paths(from, to)
    #debug "Pathfinding #{from} -> #{to}"
    queue = [[from]]
    min = Float::INFINITY
    found = []

    while queue.any?
      cur = queue.shift
      next if cur.size > min
      pos = cur.last
      #debug '-', cur, pos

      open_neighbors(pos).each do |empty|
        next if cur.include?(empty)
        path = cur + [empty]
        if empty == to
          found << path
          min = path.size if min > path.size
          #debug 'Found', min, path
        else
          queue << path
          #debug 'Queued', path
        end
      end
    end

    found.select { |path| path.size == min }
  end

  def move!(unit, pos)
    old_row, old_col = unit.pos
    row, col = pos
    occupant = terrain[row][col]
    unless occupant.open?
      raise <<-ERR
        Cannot move #{unit} from (#{old_row}, #{old_pos}) to (#{row}, #{pos}).
        A #{occupant} is there.
      ERR
    end
    unit.row, unit.col = row, col
    terrain[row][col] = unit
    occupant.row, occupant.col = old_row, old_col
    terrain[old_row][old_col] = occupant
  end

  def open_neighbors(pos)
    neighbors(pos).select { |nrow, ncol| terrain[nrow][ncol].open?  }
  end

  def neighbors(pos)
    row, col = pos
    [
      [row - 1, col],
      [row, col - 1],
      [row, col + 1],
      [row + 1, col]
    ]
  end

  private

  def setup(input, elf_power)
    @terrain = input.map.with_index do |r, row|
      r.map.with_index do |ch, col|
        case ch
        when ?G
          @goblins << Goblin.new(self, row, col)
          @goblins.last
        when ?E
          @elves << Elf.new(self, row, col, power: elf_power)
          @elves.last
        when ?#
          Wall.new(self, row, col)
        when ?.
          Open.new(self, row, col)
        end
      end
    end
  end
end

def run(elf_power)
  puts '=' * 40
  puts "Testing elves with attack power 3"
  input = File.readlines(ARGV[0]).map(&:strip).map(&:chars)
  cavern = Cavern.new(input, elf_power: elf_power)
  elf_count = cavern.elves.size
  cavern.display

  rounds = 0
  while !cavern.winner
    debug "Round", rounds
    units_to_move = cavern.units.dup
    while units_to_move.any?
      unit = units_to_move.shift
      next if unit.dead?
      unit.move! unless unit.can_attack?
      unit.attack!
      break if cavern.winner
    end
    rounds += 1 if units_to_move.empty?
    cavern.display
  end

  cavern.display
  dead_elves = elf_count - cavern.elves.size
  puts '=' * 40
  puts "Lost #{dead_elves} elves"
  puts "Victory for #{cavern.winner}."
  puts rounds * cavern.units.map(&:hp).inject(:+)

  dead_elves == 0
end

find_elf_power = ARGV[1] == 'true'
if find_elf_power
  elf_power = 3
  until run(elf_power)
    elf_power += 1
    sleep 3
  end
else
  run(3)
end
