[![Gem Version](https://badge.fury.io/rb/bugsnag-delivery-fluent.svg)](http://badge.fury.io/rb/bugsnag-delivery-fluent)
![Build Status](https://circleci.com/gh/feedforce/bugsnag-delivery-fluent.svg?style=shield)

# Bugsnag::Delivery::Fluent

This gem adds a `delivery_method` to [bugsnag/bugsnag-ruby](https://github.com/bugsnag/bugsnag-ruby) for sending to fluentd.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bugsnag-delivery-fluent'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bugsnag-delivery-fluent

## Usage

fluentd must running. Run following code, then Bugsnag sending api payload to fluentd.

```ruby
require 'bugsnag'
require 'bugsnag/delivery/fluent'

Bugsnag.configure do |config|
  config.api_key = "<BUGSNAG API KEY>"
  config.delivery_method = :fluent
  config.release_stage = 'production'
  # config.fluent_tag_prefix = 'bugsnag'
  # config.fluent_host = 'localhost'
  # config.fluent_port = 24224
end

Bugsnag.notify(RuntimeError.new("bugsnag deliver to fluentd"))
```

### data

```
{ :url => url, :body => body }
```

The data tagged `bugsnag.deliver`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/feedforce/bugsnag-delivery-fluent/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
