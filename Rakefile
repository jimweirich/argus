#!/usr/bin/env ruby"

require 'rake/clean'

task :default => :specs

task :specs do
  sh "rspec spec"
end

task :land do
  ruby "-Ilib examples/land.rb"
end
