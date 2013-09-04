require 'spec_helper'
require 'thread'

describe Argus::NavMonitor do
  Given(:streamer) { flexmock("streamer", :on, Argus::NavStreamer) }
  Given(:controller) { flexmock("controller", :on, Argus::Controller) }
  Given(:nav) {
    Argus::NavMonitor.new(controller, "localhost", streamer: streamer)
  }

  context "when the monitor is started" do
    after do nav.join end
    When { nav.start }
    Then { streamer.should have_received(:start).once }
  end

  context "when data is received" do
    Given(:bootstrap) { false }
    Given(:ack) { false }
    Given(:nav_options) { [ ] }
    Given(:nav_data) {
      flexmock("NavData",
        :bootstrap? => bootstrap,
        :control_command_ack? => ack,
        :options => nav_options)
    }

    before do
      @old_out = $stdout
      @captured_out = StringIO.new
      $stdout = @captured_out
    end

    after do
      $stdout = @old_out
    end

    When { nav.update_nav_data(nav_data) }

    context "when typical data is received" do
      Then { nav.data == nav_data }
      Then { controller.should have_received(:demo_mode).never }
      Then { controller.should have_received(:ack_control_mode).never }
    end

    context "when the bootstrap flag is set" do
      Given(:bootstrap) { true }
      Then { controller.should have_received(:demo_mode).once }
    end

    context "when the control command ack is set" do
      Given(:ack) { true }
      Then { controller.should have_received(:ack_control_mode).once }
    end

    context "with nav option sections" do
      Given(:opt) { flexmock("option", tag: 0) }
      Given(:nav_options) { [ opt ] }
      Then { nav.data == nav_data }
      Then { nav.option(0) == opt }
    end

    context "with a callback" do
      Given { nav.callback { |data| @cb_data = data } }
      Then { @cb_data == nav_data }
    end

    context "with a callback with errors" do
      Given { nav.callback { |data| fail "OUCH" } }
      Then { @captured_out.string =~ /OUCH/ }
    end
  end
end
