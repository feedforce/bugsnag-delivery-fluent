# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bugsnag/delivery/fluent/version'

Gem::Specification.new do |spec|
  spec.name          = "bugsnag-delivery-fluent"
  spec.version       = Bugsnag::Delivery::Fluent::VERSION
  spec.authors       = ["koshigoe"]
  spec.email         = ["koshigoeb@gmail.com"]

  spec.summary       = %q{Delivery method send to fluent for bugsnag/bugsnag-ruby.}
  spec.description   = %q{Delivery method send to fluent for bugsnag/bugsnag-ruby.}
  spec.homepage      = "https://github.com/feedforce/bugsnag-delivery-fluent"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-mocks'

  spec.add_runtime_dependency 'bugsnag', '~> 6.0'
  spec.add_runtime_dependency 'fluent-logger'
end
