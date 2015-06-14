require "hash_dot/version"
require 'json'

class Symbol
  def chop
    to_s.chop.to_sym
  end

  def last
    slice(-1, 1)
  end
end

class Hash
  def method_missing(method, *args)
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

  private

  def setter?(method)
    method.last == "="
  end

  def create_prop(method)
    setter?(method) ? method.chop : method
  end
end
