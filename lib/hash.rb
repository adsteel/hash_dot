# frozen_string_literal: true

class Hash
  class << self
    attr_accessor :use_dot_syntax
    attr_accessor :hash_dot_use_default
  end

  attr_accessor :use_dot_syntax
  attr_accessor :hash_dot_use_default

  def to_dot(use_default: false)
    dotify_hash(self, use_default: use_default)

    self
  end

  def method_missing(method, *args)
    return super(method, *args) unless to_dot?

    method, chain = method.to_s.split(".", 2).map(&:to_sym)

    return send(method).send(chain, *args) if chain

    prop = create_prop(method)

    if setter?(method)
      self[prop] = args.first
    elsif key?(prop) || use_default?
      self[prop]
    else
      super(method, args)
    end
  end

  def respond_to?(method, include_all = false) # rubocop:disable Style/OptionalBooleanParameter
    return super(method, include_all) unless to_dot?

    prop = create_prop(method)
    return true if key?(prop)

    super(method, include_all)
  end

  private

  def dotify_obj(obj, use_default: false)
    case obj
    when Array
      obj.each do |el|
        dotify_obj(el, use_default: use_default)
      end
    when Hash
      dotify_hash(obj, use_default: use_default)
      # else no-op
    end
  end

  def dotify_hash(hash, use_default: false)
    hash.use_dot_syntax = true
    hash.hash_dot_use_default = use_default

    hash.each_value do |val|
      dotify_obj(val, use_default: use_default)
    end
  end

  def to_dot?
    use_dot_syntax || self.class.use_dot_syntax
  end

  def use_default?
    hash_dot_use_default || self.class.hash_dot_use_default
  end

  def setter?(method)
    method.last == "="
  end

  def create_prop(method)
    prop = basic_prop_from_method(method)

    key?(prop.to_s) ? prop.to_s : prop
  end

  def basic_prop_from_method(method)
    setter?(method) ? method.chop : method
  end
end
