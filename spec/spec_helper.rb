#!/usr/bin/ruby -wKU

require 'rspec/given'
require 'flexmock'

require 'argus'
require 'support/bytes'

RSpec.configure do |config|
  config.mock_with :flexmock
end

RSpec::Given.use_natural_assertions
