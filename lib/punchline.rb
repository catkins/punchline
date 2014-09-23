require 'punchline/version'
require 'punchline/configuration'
require 'punchline/min_queue'

module Punchline
  class << self
    def config
      @config ||= Configuration.new
    end
  end
end
