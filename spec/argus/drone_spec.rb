require 'spec_helper'
require 'argus'

describe Argus::Drone do
  Given(:controller) { flexmock("controller", :on, Argus::Controller) }
  Given(:commander) { flexmock("commander", :on, Argus::ATCommander) }
  Given(:nav_monitor) { flexmock("navmonitor", :on, Argus::NavMonitor) }
  Given(:drone) {
    Argus::Drone.new(
      nav_monitor: nav_monitor,
      commander: commander,
      controller: controller)
    }

  Then { drone.commander == commander }

  context "when starting the drone" do
    When { drone.start }
    Then { commander.should have_received(:start).once }
    Then { nav_monitor.should have_received(:start).once }

    context "and then stopped" do
      When { drone.stop }
      Then { controller.should have_received(:land).once }
      Then { commander.should have_received(:stop).once }
      Then { commander.should have_received(:join).once }
      Then { nav_monitor.should have_received(:stop).once }
      Then { nav_monitor.should have_received(:join).once }
    end
  end

  describe "setting nav callbacks" do
    When { drone.nav_callback(:a) }
    Then { nav_monitor.should have_received(:callback).with(:a).once }
  end

  describe "flight controls" do
    When { drone.take_off }
    Then { controller.should have_received(:take_off).once }
  end

  context "when created normally" do
    Given { flexmock(Argus::NavMonitor).should_receive(:new => nil) }
    When { Argus::Drone.new }
    Then { Argus::NavMonitor.should have_received(:new).with(Argus::Controller, String).once }
  end

  context "when NavMonitor is disabled" do
    Given { flexmock(Argus::NullNavMonitor).should_receive(:new => nil) }
    When { Argus::Drone.new(enable_nav_monitor: false) }
    Then { Argus::NullNavMonitor.should have_received(:new).with().once }
  end
end
