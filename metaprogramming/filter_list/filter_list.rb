# frozen_string_literal: true

class Object
  def try(name, *args, &blk)
    send(name, *args, &blk)
  rescue NoMethodError
    nil
  end
end

class FilterList
  def initialize(*args)
    @_arr = Array(args).flatten(1)
  end

  def self.delegate(*names, to:)
    names.each do |name|
      define_method(name) do |*args, &blk|
        send(to).send(name, *args, &blk)
      end
    end
  end

  delegate :any?,
           :empty?,
           :count,
           :first,
           :select,
           :reject,
           :inject,
           :map,
           to: :_arr

  def to_a() = _arr

  private

  attr_reader :_arr

  def method_missing(name, *args, &blk)
    case name.to_s
    when /^is_not_/
      sub_name = name.to_s.gsub(/^is_not_/, "")
      if any? { _1.respond_to?(sub_name) }
        self.class.new(reject { _1.try(sub_name) })
      elsif any? { _1.respond_to?("#{sub_name}?") }
        self.class.new(reject { _1.try("#{sub_name}?") })
      else
        super
      end
    when /^is_/
      sub_name = name.to_s.gsub(/^is_/, "")
      if any? { _1.respond_to?(sub_name) }
        self.class.new(select { _1.try(sub_name) })
      elsif any? { _1.respond_to?("#{sub_name}?") }
        self.class.new(select { _1.try("#{sub_name}?") })
      else
        super
      end
    else super
    end
  end

  def respond_to?(name)
    case name.to_s
    when /^is_not_/
      any? { _1.respond_to(name.gsub(/^is_not_/, ""))} || super
    when /^is_/
      any? { _1.respond_to(name.gsub(/^is_/, ""))} || super
    else super
    end
  end
end
