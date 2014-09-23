require 'coveralls'
Coveralls.wear!

require 'pry'
require 'punchline'
require 'timecop'

RSpec.configure do |config|
  config.after(:each) do

    # always unfreeze timecop after specs
    Timecop.return

  end
end
