# HashDot

HashDot allows you to call your Ruby hash properties with a dot syntax. Simply include the gem in your project and starting using the dot syntax.

```ruby
  user = {name: 'Anna', job: {title: 'Programmer'}}

  user.job.title #=> 'Programmer'
  user.job.title = 'Senior Programmer'
  user.job.title #=> 'Senior Programmer'
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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adsteel/hash_dot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

