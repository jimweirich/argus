--- !ruby/object:Gem::Specification
name: hybridgroup-argus
version: !ruby/object:Gem::Version
  version: 0.4.0
platform: ruby
authors:
- Jim Weirich
- Ron Evans
- Adrian Zankich
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
- lib/argus/cad_type.rb
- lib/argus/cfields.rb
- lib/argus/controller.rb
- lib/argus/drone.rb
- lib/argus/float_encoding.rb
- lib/argus/led_animation.rb
- lib/argus/nav_data.rb
- lib/argus/nav_monitor.rb
- lib/argus/nav_option.rb
- lib/argus/nav_option_checksum.rb
- lib/argus/nav_option_demo.rb
- lib/argus/nav_option_unknown.rb
- lib/argus/nav_option_vision_detect.rb
- lib/argus/nav_streamer.rb
- lib/argus/nav_tag.rb
- lib/argus/time_queue.rb
- lib/argus/udp_sender.rb
- lib/argus/version.rb
- lib/argus/video_data.rb
- lib/argus/video_data_envelope.rb
- lib/argus/video_streamer.rb
- spec/spec_helper.rb
- spec/argus/at_commander_spec.rb
- spec/argus/controller_spec.rb
- spec/argus/drone_spec.rb
- spec/argus/float_encoding_spec.rb
- spec/argus/led_animation_spec.rb
- spec/argus/nav_data_spec.rb
- spec/argus/nav_option_checksum_spec.rb
- spec/argus/nav_option_demo_spec.rb
- spec/argus/nav_option_spec.rb
- spec/argus/nav_option_unknown_spec.rb
- spec/argus/nav_option_vision_detect_spec.rb
- spec/argus/nav_streamer_spec.rb
- spec/argus/time_queue_spec.rb
- spec/argus/udp_sender_spec.rb
- spec/argus/video_data_envelope_spec.rb
- spec/argus/video_data_spec.rb
- spec/argus/video_streamer_spec.rb
- spec/support/bytes.rb
- MIT-LICENSE
homepage: http://github.com/jimweirich/argus
licenses: []
metadata: {}
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
  - - '>='
    - !ruby/object:Gem::Version
      version: '1.9'
required_rubygems_version: !ruby/object:Gem::Requirement
  none: false
  requirements:
  - - '>='
    - !ruby/object:Gem::Version
      version: '1.0'
requirements: []
rubyforge_project: n/a
rubygems_version: 2.0.3
signing_key: 
specification_version: 4
summary: Ruby API for a Parrot AD Drone Quadcopter
test_files: []
