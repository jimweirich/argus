#!/usr/bin/env ruby

source 'https://rubygems.org'

gem 'celluloid'
gem 'rake'

group :testing do
  gem 'rspec-given'
  gem 'pry'
  gem 'flexmock', :require => false
  gem 'simplecov', :require => false
  
  platforms :rbx do
    gem 'rubinius-coverage'
  end
end
