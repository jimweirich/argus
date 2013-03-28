--- !ruby/object:Gem::Specification
name: argus
version: !ruby/object:Gem::Version
  version: 0.0.0
  prerelease: 
platform: ruby
authors:
- Jim Weirich
- Ron Evans
autorequire: 
bindir: bin
cert_chain: []
date: 2013-01-19 00:00:00.000000000 Z
dependencies:
- !ruby/object:Gem::Dependency
  name: rspec-given
  requirement: !ruby/object:Gem::Requirement
    none: false
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: '2.1'
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    none: false
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: '2.1'
description: Argus is a Ruby interface to a Parrot AR Drone quadcopter.Argus is extremely
  experimental at this point.  Use at your own risk.
email:
- jim.weirich@gmail.com
- ron dot evans at gmail dot com
executables: []
extensions: []
extra_rdoc_files:
- README.md
- MIT-LICENSE
files:
- README.md
- Rakefile
- lib/argus.rb
- lib/argus/at_commander.rb
- lib/argus/controller.rb
- lib/argus/drone.rb
- lib/argus/udp_sender.rb
- lib/argus/version.rb
- spec/spec_helper.rb
- spec/argus/at_commander_spec.rb
- spec/argus/controller_spec.rb
- spec/argus/udp_sender_spec.rb
- MIT-LICENSE
homepage: http://github.com/jimweirich/argus
licenses: []
post_install_message: 
rdoc_options:
- --line-numbers
- --show-hash
- --main
- README.md
- --title
- Argus -- Parrot AR Drone Ruby API
require_paths:
- lib
required_ruby_version: !ruby/object:Gem::Requirement
  none: false
  requirements:
  - - ! '>='
    - !ruby/object:Gem::Version
      version: '1.9'
required_rubygems_version: !ruby/object:Gem::Requirement
  none: false
  requirements:
  - - ! '>='
    - !ruby/object:Gem::Version
      version: '1.0'
requirements: []
rubyforge_project: n/a
rubygems_version: 1.8.24
signing_key: 
specification_version: 3
summary: Ruby API for a Parrot AD Drone Quadcopter
test_files: []
