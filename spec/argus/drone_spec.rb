require 'spec_helper'

module Argus
  describe Drone do

    Given(:socket) { flexmock("Socket", send: nil).should_ignore_missing }
    Given(:drone) { Drone.new(socket) }

    describe "default navigation monitor enabled" do
      Then { drone.enable_nav_monitor == false }
    end

    describe "default navigation monitor enabled when started" do
      When { drone.start }
      Then { drone.enable_nav_monitor == true }
    end

    describe "navigation monitor can be disabled when started" do
      When { drone.start(false) }
      Then { drone.enable_nav_monitor == false }
    end
  end
end

