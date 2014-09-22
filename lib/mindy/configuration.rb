require 'redis'

module Mindy
  class Configuration
    attr_accessor :redis

    def initialize(redis = nil)
      @redis = redis || Redis.new
    end
  end
end
