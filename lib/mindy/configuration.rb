module Mindy
  class Configuration < Struct.new(:redis)
    class << self
      def redis
        super || @redis ||= Redis.new
      end
    end
  end
end
