# Encoding: utf-8

require 'redis'

module Punchline
  class Configuration
    attr_accessor :redis

    def initialize(redis = nil)
      @redis = redis || Redis.new
    end
  end
end
