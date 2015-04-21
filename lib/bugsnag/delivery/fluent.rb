require 'bugsnag'
require 'bugsnag/delivery'
require 'bugsnag/delivery/fluent/version'
require 'fluent-logger'

module Bugsnag
  module FluentConfiguration
    def self.included(klass)
      klass.class_eval do
        attr_accessor :fluent_tag_prefix
        attr_accessor :fluent_host
        attr_accessor :fluent_port
      end
      Bugsnag.configuration.fluent_tag_prefix = 'bugsnag'
      Bugsnag.configuration.fluent_host = 'localhost'
      Bugsnag.configuration.fluent_port = 24224
    end
  end

  class Configuration
    include FluentConfiguration
  end

  module Delivery
    class Fluent
      def self.deliver(url, body, configuration)
        @logger ||= ::Fluent::Logger::FluentLogger.new(
          configuration.fluent_tag_prefix,
          :host => configuration.fluent_host,
          :port => configuration.fluent_port
        )
        unless @logger.post('deliver', { :url => url, :body => body })
          configuration.logger.error @logger.last_error
        end
      end
    end
  end
end

Bugsnag::Delivery.register(:fluent, Bugsnag::Delivery::Fluent)
