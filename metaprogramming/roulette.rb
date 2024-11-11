class Foo
  def respond_to_missing?(*args)
    super
  end

  def method_missing(name, *args)
    puts "Foo#method_missing(#{name}#{', ' if args.any?}#{args.join(', ')})"
    "foo_return"
  end
end

class Roulette
  def emp_names
    # %w[bob frank bill]
    @emp_names ||= EmployeeRepository.all_first_name
  end

  def method_missing(name, *args)
    return super unless NAMES.to_s.include? name

    person = name.to_s.capitalize
    number = 0
    3.times do
      number = rand(1..10)
      puts "#{number}..."
    end
    "#{person} got a #{number}"
  end
end

class Bar < Foo
  def respond_to_missing(*args)
    super
  end

  def method_missing(name, *args)
    puts "Bar#method_missing(#{name}#{', ' if args.any?}#{args.join(', ')})"
    return super if name.to_s == "foo"
    "bar_return"
  end
end

def determine_age(user)
  return user.age if user.age.present?

  some_long_process_examining_purchasing_patterns
end

def all_users(program_id)
  return User.all if program_id.nil?

  User.where(program_id: program_id)
end















class Foo
  REQ_ATTRS = %i[foo bar baz].freeze
  OPT_ATTRS = %i[qux].freeze

  (OPT_ATTRS + REQ_ATTRS).each do |attr|
    define_method "#{attr}?" do
      self.attr.present?
    end

    define_method "#{attr}=" do |val|
      self[attr] = val
    end
  end

  REQ_ATTRS.each do |attr|
    define_method attr do
      raise "#{attr} is required, but missing" unless defined?(self[:attr])

      self[attr]
    end
  end

  OPT_ATTRS.each do |attr|
    define_method attr do
      return unless defined?(self[:attr])

      self[attr]
    end
  end

  def method_missing(name, *attrs)
    stripped_name = name.to_s.gsub("=", "").to_sym

    define_method stripped_name { self[stripped_name] }
    define_method "#{stripped_name}=" { self[stripped_name] = _1 }

    self.send(name)
end

      self[stripped_name] = attrs[0]
    elsif name=~ /\?$/
      !self[stripped_name].nil?
    elsif name == stripped_name
      self[stripped_name]
    else
      super
    end
  end
end



class User << ApplicationRecord
  scope :is_over, ->(age) { where(age: age..) }
  scope :is_registered. -> { where(registered: true) }

  def self.is_over(age)
    where(age: age..)
  end
end


User.is_over(35).is_registered.where(name: "Nick").where.not(email: "randland@gmail.com")







