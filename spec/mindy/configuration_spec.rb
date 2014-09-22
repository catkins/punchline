require 'spec_helper'

module Mindy
  describe Configuration do
    subject(:config) { Configuration.new }

    it { should respond_to :redis }

    describe '#redis' do
      subject(:redis) { config.redis }
      it { should_not be_nil }
    end
  end
end
