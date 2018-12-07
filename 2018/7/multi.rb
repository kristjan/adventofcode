input = File.readlines(ARGV[0])
WORKERS = ARGV[1].to_i
BASE_TIME = ARGV[2].to_i

class Step
  attr_reader :name, :pres, :done

  def initialize(name, done)
    @done = done
    @name = name
    @pres = []
  end

  def ready?
    pres.all? {|pre| done.include?(pre)}
  end

  def time
    name.ord - 65 + 1 + BASE_TIME
  end

  def finished
    pres.select {|pre| done.include?(pre)}
  end

  def left
    pres - finished
  end

  def to_s
    "#{name} := #{left.map(&:name).join} | #{finished.map(&:name).join}"
  end
end

class Job
  attr_reader :step, :remaining

  def initialize(step)
    @step = step
    @remaining = step.time
  end

  def tick!
    @remaining -= 1
  end

  def done?
    @remaining == 0
  end
end

steps = {}
done = []

input.each do |line|
  parts = line.split(' ')
  pre = parts[1]
  name = parts[-3]
  steps[pre] ||= Step.new(pre, done)
  steps[name] ||= Step.new(name, done)
  steps[name].pres << steps[pre]
end

puts steps.values.sort_by{|s| s.pres.size}

tick = 0
jobs = []

while steps.any? || jobs.any?
  just_finished = jobs.select(&:done?)
  jobs -= just_finished
  done.concat(just_finished.map(&:step))

  ready = steps.values.select(&:ready?).sort_by(&:name)

  todo = ready.first(WORKERS - jobs.size)
  jobs.concat(todo.map {|step| Job.new(step)})
  todo.each {|step| steps.delete(step.name)}

  puts [tick, *WORKERS.times.map{|i| jobs[i]&.step&.name}, done.map(&:name).join].join("\t")
  jobs.each(&:tick!)
  tick += 1
end

puts done.map(&:name).join
puts tick - 1
