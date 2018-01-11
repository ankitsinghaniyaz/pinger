# Pinger

Pinger probes a given website for responses. It makes requests to the destination website
for the specified duration in the specified interval. It computes the final mean response time
and make it available to the users

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pinger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pinger

## Usage

Usage: pinger [options] url
    -i, --interval N                 Probe interval in seconds, default: 10 seconds
    -d, --duration D                 Duration to run the test, deafult: 60 seconds


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pinger.
