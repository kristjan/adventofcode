data = File.readlines(ARGV[0]).each(&:strip!)

collide = !!ARGV.delete('--collide')

class Vector
  attr_accessor :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end
end

class Particle
  attr_accessor :p, :v, :a, :name

  def initialize(name, p, v, a)
    @name, @p, @v, @a = name, p, v, a
  end

  def dist
    p.x.abs + p.y.abs + p.z.abs
  end

  def step
    v.x += a.x
    v.y += a.y
    v.z += a.z
    p.x += v.x
    p.y += v.y
    p.z += v.z
  end
end

particles = data.map.with_index do |line, i|
  p, v, a = line.split(', ').map{|d| d.scan(/-?\d+/).map(&:to_i)}
  Particle.new(
    i,
    Vector.new(*p),
    Vector.new(*v),
    Vector.new(*a)
  )
end

10000.times do
  particles.each(&:step)
  if collide
    particles.group_by do |p|
      [p.p.x, p.p.y, p.p.z]
    end.select do |g, ps|
      ps.size > 1
    end.each do |g, ps|
      particles -= ps
    end
  end
end

puts "Closest: #{particles.sort_by(&:dist).first.name}"
puts "Remaining: #{particles.size}"
