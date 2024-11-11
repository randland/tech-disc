class Object
  def try(name, *args)
    return self.send(name, *args) if respond_to?(name)
    nil
  end

  def try!(name, *args)
    return self.name(*args) if respond_to?(name)
    raise NoMethodError, name
  end
end

class FilterList
  def initialize(*objects)
    @objects = Array(objects).flatten
  end

  def to_a
    objects.dup
  end

  def respond_to?(name, include_private = false)
    if name =~ /_is$/
      attr = name.to_s.gsub('_is', '')
      return true if objects.any? { _1.respond_to?(attr) }
    end

    super
  end

  private

  attr_reader :objects

  def method_missing(name, *args, &block)
    if name =~ /_is$/
      attr = name.to_s.gsub('_is', '')
      return filter_by(attr, *args) if objects.any? { _1.respond_to?(attr) }
    end

    super
  end

  def filter_by(attr, *args)
    first_arg = Array(args).flatten.first

    case first_arg
    when Hash
      k, v = first_arg.first

      case k
      when :eq  then new_selection { _1.try(attr) == v }
      when :not then new_selection { _1.try(attr) != v }
      when :gt  then new_selection { _1.try(attr) > v unless _1.try(attr).nil? }
      when :gte then new_selection { _1.try(attr) >= v unless _1.try(attr).nil? }
      when :lt  then new_selection { _1.try(attr) < v unless _1.try(attr).nil? }
      when :lte then new_selection { _1.try(attr) <= v unless _1.try(attr).nil? }
      end
    when Range
      new_selection { first_arg.cover?(_1.send(attr)) }
    when Regexp
      new_selection { _1.try(attr) =~ first_arg if _1.try(attr).respond_to?(:match) }
    else new_selection { _1.try(attr) == first_arg }
    end
  end

  def new_selection(&blk)
    self.class.new(objects.select(&blk))
  end
end
