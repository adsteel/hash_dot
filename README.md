# HashDot

HashDot allows you to call your Ruby hash properties with a dot syntax.

```ruby
  require 'hash_dot'
  HashDot.universal_dot_syntax = true

  user = {name: 'Anna', job: {title: 'Programmer'}}

  user.job.title #=> 'Programmer'
  user.job.title = 'Senior Programmer'
  user.job.title #=> 'Senior Programmer'
  user.job.delete(:title)
  user.job.title #=> NoMethodError
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_dot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_dot


## Configuration

To allow dot syntax for all of your hashes, simply configure your app with the following:

```ruby
HashDot.universal_dot_syntax = true
```

You can revert to default behavior as well.

```ruby
HashDot.universal_dot_syntax = false
```

## Benchmarks
Benchmarks should be taken with a grain of salt, as always. For example, OpenStruct is much slower to initialize, but calls its methods faster once initialized. The OpenStruct solution also can't traverse more than a single dot without recursively instantiating all sub-hashes into OpenStructs.

```Ruby
require 'ostruct'
require 'benchmark'
require 'hash_dot'

user = { address: { category: { desc: 'Urban'}}}

iterations = 50000

Benchmark.bm(8) do |bm|
  bm.report("Default Notation   :") {
    iterations.times do; user[:address][:category][:desc]; end
  }

  bm.report("Dot Notation       :") {
    iterations.times do; user.address.category.desc; end
  }

  bm.report("OpenStruct         :") {
    iterations.times do; OpenStruct.new(user); end
  }

  # Minus OpenStruct instantiation cost
  os_user = OpenStruct.new(user)
  bm.report("OpenStruct Single  :") {
    iterations.times do; os_user.address; end
  }

  bm.report("Dot Notation Single:") {
    iterations.times do; user.address; end
  }
end

# Benchmark Example
#                       user     system      total        real
Default Notation   :  0.010000   0.000000   0.010000 (  0.008807)
Dot Notation       :  0.190000   0.000000   0.190000 (  0.195819)
OpenStruct         :  0.400000   0.010000   0.410000 (  0.399542)
OpenStruct Single  :  0.010000   0.000000   0.010000 (  0.011259)
Dot Notation Single:  0.080000   0.000000   0.080000 (  0.082606)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adsteel/hash_dot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](CODE_OF_CONDUCT.md) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

