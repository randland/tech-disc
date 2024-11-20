class Event
  attr_reader :error_message, :block

  def initialize(error_message, &block)
    @error_message = error_message
    @block = block
  end

  def run
    puts "#{user}: #{error_message}" if block.call
  end
end

class Runner
  attr_reader :events, :lets

  def initialize
    @events = []
    @lets = {}
  end

  def iv_name(name)
    "@__#{name}"
  end

  def method_missing(name, *args, &block)
    if lets[name]
      return instance_variable_get(iv_name(name)) if instance_variable_defined?(iv_name(name))

      instance_variable_set(iv_name(name), instance_eval(&lets[name]))
    end
  end

  def let(name, &block)
    lets.merge!(name => block)
  end

  def event(error_message, &block)
    events << Event.new(error_message, &block)
  end

  def run
    events.each(&:run)
  end

  def self.notify_of_events(&block)
    new.tap { _1.instance_eval(&block) }.run
  end
end

Runner.notify_of_events do
  let(:val) { 500 }

  event("Val is too high") do
    val > 100
  end

  event("Val is too low") do
    val < 10
  end

  event("Val is Even!") do
    val.even?
  end
end
