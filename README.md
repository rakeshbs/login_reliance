# LoginReliance

This gem is used to login to reliance broadband connection.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'login_reliance'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install login_reliance

## Usage

Run

    $ login_reliance

It will prompt for username and password. If you wish to save the password, it will be written to a file in a the home directory. The name of the file is reliance.

Run the following to keep trying to login.

    $ login_reliance -r

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rakeshbs/login_reliance.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

