require 'spec_helper'

describe Bugsnag::Delivery::Fluent do
  it 'has a version number' do
    expect(Bugsnag::Delivery::Fluent::VERSION).not_to be nil
  end

  it 'registered to Bugsnag::Delivery' do
    expect(Bugsnag::Delivery[:fluent]).to eq(described_class)
  end

  describe '.deliver' do
    let(:fluent_logger) { double('Fluent::Logger::FluentLogger') }
    let(:url) { 'http://www.example.com/' }
    let(:body) { 'json body' }
    let(:configuration) { Bugsnag.configuration }
    let(:post_result) { nil }

    before do
      expect(::Fluent::Logger::FluentLogger).to receive(:new).and_return(fluent_logger)
      expect(fluent_logger).to receive(:post).with('deliver', { :url => url, :body => body }).and_return(post_result)
    end

    subject { described_class.deliver(url, body, configuration) }

    context 'send successful' do
      let(:post_result) { true }

      it do
        expect(fluent_logger).to_not receive(:last_error)
        expect(Bugsnag.configuration.logger).to_not receive(:error)
        subject
      end
    end

    context 'send failed' do
      let(:post_result) { false }

      it do
        expect(fluent_logger).to receive(:last_error).and_return('LAST ERROR')
        expect(Bugsnag.configuration.logger).to receive(:error).with('LAST ERROR')
        subject
      end
    end
  end
end
