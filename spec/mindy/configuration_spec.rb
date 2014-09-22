require 'spec_helper'

module Mindy
  describe Configuration do
    subject(:config) { Configuration.new }

    it { should respond_to :redis }
  end
end
