class Hash
  class << self
    attr_accessor :use_dot_syntax
  end

  attr_accessor :use_dot_syntax

  def to_dot
    dotify_hash(self)

    self
  end

  def method_missing(method, *args)
    return super(method, *args) unless to_dot?

    prop = create_prop(method)

    if self[prop].nil?
      self[prop] = self.delete(prop.to_s)
    end

    super(method, args) and return if self[prop].nil?

    if setter?(method)
      self[prop] = args.first
    else
      self[prop]
    end
  end

  private def dotify_hash(hash)
    hash.use_dot_syntax = true

    hash.keys.each { |key| dotify_hash(hash[key]) if hash[key].is_a?(Hash) }
  end

  private def to_dot?
    self.use_dot_syntax || self.class.use_dot_syntax
  end

  private def setter?(method)
    method.last == "="
  end

  private def create_prop(method)
    setter?(method) ? method.chop : method
  end
end
