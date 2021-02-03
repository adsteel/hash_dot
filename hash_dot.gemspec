# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_dot/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_dot"
  spec.version       = HashDot::VERSION
  spec.authors       = ["Adam Steel"]
  spec.email         = ["adamgsteel@gmail.com"]

  spec.summary       = %q{Use dot syntax with Ruby hashes.}
  spec.description   = %q{HashDot allows you to call hash properties with a dot the same way you would call, say, ActiveRecord relationships and attributes. More traversable and often faster than OpenStruct.}
  spec.homepage      = "https://github.com/adsteel/hash_dot"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "json", '>= 2.5.1'
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop"
end
