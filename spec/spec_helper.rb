#!/usr/bin/ruby -wKU

require 'rspec/given'
require 'flexmock'

require 'argus'

RSpec.configure do |config|
  config.mock_with :flexmock
end
