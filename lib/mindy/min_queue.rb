# Encoding: utf-8

module Mindy
  class MinQueue

    attr_accessor :key

    def initialize(key)
      @key = key
      load_scripts!
    end

    def config
      @config ||= Mindy.config.dup
    end

    def length
      redis.zcard key
    end

    def enqueue(priority: Time.now.to_i, value: '')
      @enqueue.call [key], [priority, value]
    end

    def dequeue
      value, priority = @dequeue.call [key]

      { value: value, priority: priority.to_i } unless value.nil?
    end

    def redis
      config.redis
    end

    def load_scripts!
      @enqueue = Script.new redis, 'enqueue.lua'
      @dequeue = Script.new redis, 'dequeue.lua'
    end

    def clear!
      redis.del key
    end

    def reset_scripts!
      redis.script :flush
    end


    class Script
      SCRIPT_BASE_PATH = File.expand_path('../lua', __FILE__)

      attr_accessor :redis, :body, :sha, :script_name

      def initialize(redis, script_name)
        @redis = redis
        @script_name = script_name
      end

      def call(keys = [], argv = [])
        load! unless @body
        @redis.evalsha sha, keys, argv
      end

      private

      def load!
        path = File.join SCRIPT_BASE_PATH, script_name
        @body = File.read path
        @sha  = redis.script :load, body
      end
    end
  end
end
