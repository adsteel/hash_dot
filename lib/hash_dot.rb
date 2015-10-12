require "hash_dot/version"
require 'symbol'
require 'hash'

module HashDot
  class << self
    attr_accessor :universal_dot_syntax

    universal_dot_syntax ||= false
  end
end
