# Encoding: utf-8

module Punchline
  class MinQueue

    attr_accessor :key

    def initialize(key)
      @key = key
      load_scripts!
    end

    def config
      @config ||= Punchline.config.dup
    end

    def length
      redis.zcard key
    end

    def all
      redis.zrange(key, 0, -1, with_scores: true).map do |pair|
        { value: pair.first, priority: pair.last.to_i }
      end
    end

    def enqueue(value, options = {})
      priority = options[:priority] || Time.now.to_i
      @enqueue.call([key], [priority, value]) == 1
    end

    def dequeue
      value, priority = @dequeue.call [key]

      { value: value, priority: priority.to_i } unless value.nil?
    end

    def redis
      config.redis
    end


    def clear!
      redis.del key
    end

    def reset_scripts!
      redis.script :flush
    end

    private

    def load_scripts!
      @enqueue = Script.new redis, 'enqueue.lua'
      @dequeue = Script.new redis, 'dequeue.lua'
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
