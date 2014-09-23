require 'punchline/version'
require 'punchline/configuration'
require 'punchline/min_queue'

module Punchline
  class << self
    def configure(&block)
      yield config if block_given?
    end

    def config
      @config ||= Configuration.new
    end
  end
end
