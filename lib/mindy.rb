require "mindy/version"
require "mindy/configuration"
require "mindy/min_queue"

module Mindy
  class << self
    def config
      @config ||= Configuration.new
    end
  end
end
