require 'spec_helper'
require 'bugsnag/delivery/fluent'

RSpec.describe Bugsnag::Configuration do
  describe '.configuration' do
    subject { Bugsnag.configuration }

    it { expect(subject).to be_respond_to(:fluent_tag_prefix) }
    it { expect(subject).to be_respond_to(:fluent_host) }
    it { expect(subject).to be_respond_to(:fluent_port) }
    it { expect(subject.fluent_tag_prefix).to eq('bugsnag')  }
    it { expect(subject.fluent_host).to eq('localhost')  }
    it { expect(subject.fluent_port).to eq(24224)  }
  end
end
