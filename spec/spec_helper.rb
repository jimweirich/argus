#!/usr/bin/ruby -wKU
require 'simplecov'
SimpleCov.start

require 'rspec/given'
require 'flexmock'
require 'argus'
require 'support/bytes'
require 'support/capture_io'

RSpec.configure do |config|
  config.mock_with :flexmock
end

RSpec::Given.use_natural_assertions
