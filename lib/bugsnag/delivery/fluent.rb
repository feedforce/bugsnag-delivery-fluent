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
      def self.deliver(url, body, configuration, options = {})
        begin
          logger = ::Fluent::Logger::FluentLogger.new(
            configuration.fluent_tag_prefix,
            :host => configuration.fluent_host,
            :port => configuration.fluent_port
          )
          if logger.post('deliver', { :url => url, :body => body, :options => options })
            configuration.debug("Notification to #{url} finished, payload was #{body}")
          else
            configuration.warn("Notification to #{url} failed, #{logger.last_error}")
          end
        rescue StandardError => e
          raise if e.class.to_s == "RSpec::Expectations::ExpectationNotMetError"

          configuration.warn("Notification to #{url} failed, #{e.inspect}")
          configuration.warn(e.backtrace)
        end
      end
    end
  end
end

Bugsnag::Delivery.register(:fluent, Bugsnag::Delivery::Fluent)
