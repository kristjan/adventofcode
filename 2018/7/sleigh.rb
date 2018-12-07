input = File.readlines(ARGV[0])

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
    name.ord - 65
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


while steps.any?
  ready = steps.values.select(&:ready?)
  todo = ready.sort_by(&:name).first
  done << todo
  steps.delete(todo.name)
end

order = done.map(&:name)
puts order.join(',')
