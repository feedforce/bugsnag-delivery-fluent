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
    end

    subject { described_class.deliver(url, body, configuration, {}) }

    context 'send successful' do
      before do
        expect(fluent_logger).to receive(:post).with('deliver', { :url => url, :body => body }).and_return(true)
      end

      it do
        expect(fluent_logger).to_not receive(:last_error)
        expect(configuration).to_not receive(:warn)
        subject
      end
    end

    context 'send failed' do
      context 'fluent logger return false' do
        before do
          expect(fluent_logger).to receive(:post).with('deliver', { :url => url, :body => body }).and_return(false)
        end

        it do
          expect(fluent_logger).to receive(:last_error).and_return('LAST ERROR')
          expect(configuration).to receive(:warn).with('Notification to http://www.example.com/ failed, LAST ERROR')
          subject
        end
      end

      context 'fluent logger raise exception' do
        before do
          expect(fluent_logger).to receive(:post).with('deliver', { :url => url, :body => body }).and_raise
        end

        it do
          expect(fluent_logger).to_not receive(:last_error)
          expect(configuration).to receive(:warn).exactly(2).times
          subject
        end
      end
    end
  end
end
