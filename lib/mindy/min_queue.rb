require "pry"

module Mindy
  class MinQueue

    attr_accessor :key

    def initialize(key)
      @key = key
    end

    def config
      @config ||= Mindy.config.dup
    end

    def length
      redis.zcard key
    end

    def enqueue

    end

    def dequeue

    end

    def redis
      config.redis
    end
  end
end
