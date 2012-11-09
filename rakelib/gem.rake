require 'rubygems/package_task'
require './lib/argus/version'

if ! defined?(Gem)
  puts "Package Target requires RubyGems"
else
  PKG_FILES = FileList['README.md', 'Rakefile', 'lib/*.rake']
  BASE_RDOC_OPTIONS = [
    '--line-numbers',
    '--show-hash',
    '--main', 'README.md',
    '--title', 'Argus -- Parrot AR Drone Ruby API'
  ]
  SPEC = Gem::Specification.new do |s|
    s.name = 'argus'
    s.version = Argus::VERSION
    s.summary = "Ruby API for a Parrot AD Drone Quadcopter"
    s.description = <<-EOF.delete "\n"
Argus is a Ruby library to interface to a Parrot AR Drone quadcopter.

Argus is experimental.  Use at your own risk.
    EOF

    s.required_ruby_version = '>= 1.9'
    s.required_rubygems_version = '>= 1.0'
    s.add_development_dependency 'rspec-given', '~> 2.1'

    s.files = PKG_FILES.to_a

    s.executables = []

    s.extra_rdoc_files = FileList[
      'README.md',
      'MIT-LICENSE'
    ]

    s.rdoc_options = BASE_RDOC_OPTIONS

    s.author = "Jim Weirich"
    s.email = "jim.weirich@gmail.com"
    s.homepage = "http://github.com/jimweirich/argus"
    s.rubyforge_project = "n/a"
  end

  Gem::PackageTask.new(SPEC) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  file "argus.gemspec" => ["Rakefile"] do |t|
    require 'yaml'
    open(t.name, "w") { |f| f.puts SPEC.to_yaml }
  end

  desc "Create a stand-alone gemspec"
  task :gemspec => "argus.gemspec"
end
