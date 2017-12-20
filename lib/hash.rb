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
    method, chain = method.to_s.split('.', 2).map(&:to_sym)
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

  def respond_to?(method, include_all=false)
    return super(method, include_all) unless to_dot?
    prop = create_prop(method)
    return true if key?(prop)
    super(method, include_all)
  end

  private

  def dotify_hash(hash, use_default: false)
    hash.use_dot_syntax = true
    hash.hash_dot_use_default = use_default

    hash.keys.each { |key| dotify_hash(hash[key], use_default: use_default) if hash[key].is_a?(Hash) }
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
