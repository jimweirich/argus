require 'spec_helper'

describe Argus::Controller do

  REF_BASE = 0x11540000

  def ref_bits(n=nil)
    if n.nil?
      REF_BASE.to_s
    else
      (REF_BASE | (1 << n)).to_s
    end
  end

  Given(:at) { flexmock(:on, Argus::ATCommander) }
  Given(:controller) { Argus::Controller.new(at) }

  describe "controller commands" do
    Invariant { result.should == controller }

    context "navigating commands" do
      context "when taking off" do
        When(:result) { controller.take_off }
        Then { at.should have_received(:ref).with(ref_bits(9)) }
      end

      context "when landing" do
        When(:result) { controller.land }
        Then { at.should have_received(:ref).with(ref_bits).twice }
      end

      context "when enable_emergency" do
        Given { controller.enable_emergency }
        When(:result) { controller.take_off }
        Then { at.should have_received(:ref).with(ref_bits(9)) }
      end

      context "when taking off after a disable_emergency" do
        Given { controller.disable_emergency }
        When(:result) { controller.take_off }
        Then { at.should have_received(:ref).with(ref_bits(8)) }
      end

      context "when hovering" do
        When(:result) { controller.hover }
        Then { at.should have_received(:pcmd).with("0,0,0,0,0") }
      end

      context "when moving forward" do
        When(:result) { controller.forward(0.80) }
        Then { at.should have_received(:pcmd).with("1,0,-1085485875,0,0") }
      end

      context "when moving backward" do
        When(:result) { controller.backward(0.80) }
        Then { at.should have_received(:pcmd).with("1,0,1061997773,0,0") }
      end

      context "when moving to the left" do
        When(:result) { controller.left(0.80) }
        Then { at.should have_received(:pcmd).with("1,-1085485875,0,0,0") }
      end

      context "when moving to the right" do
        When(:result) { controller.right(0.80) }
        Then { at.should have_received(:pcmd).with("1,1061997773,0,0,0") }
      end

      context "when moving up" do
        When(:result) { controller.up(0.80) }
        Then { at.should have_received(:pcmd).with("1,0,0,1061997773,0") }
      end

      context "when moving down" do
        When(:result) { controller.down(0.80) }
        Then { at.should have_received(:pcmd).with("1,0,0,-1085485875,0") }
      end

      context "when turning left" do
        When(:result) { controller.turn_left(0.80) }
        Then { at.should have_received(:pcmd).with("1,0,0,0,-1085485875") }
      end

      context "when turning right" do
        When(:result) { controller.turn_right(0.80) }
        Then { at.should have_received(:pcmd).with("1,0,0,0,1061997773") }
      end

      context "when executing several directions" do
        When(:result) {
          controller.forward(1.0).left(0.5).up(0.2).turn_left(0.8)
        }
        Then { at.should have_received(:pcmd).with("1,-1090519040,-1082130432,1045220557,-1085485875") }
      end
    end

    describe "config command" do
      context "when setting with numeric sequence" do
        When(:result) { controller.led(3, 2.0, 4) }
        Then {
          at.should have_received(:config)
            .with("leds:leds_anim", "3,1073741824,4")
        }
      end

      context "when setting with symbolic sequence" do
        When(:result) { controller.led(:blink_orange, 2.0, 4) }
        Then {
          at.should have_received(:config)
            .with("leds:leds_anim", "3,1073741824,4")
        }
      end
    end

    describe "enabled detection command" do
      context "when setting all parameters" do
        Given(:enemy)  { 2 }
        Given(:type)   { 11 }
        Given(:select) { 33 }

        When(:result) { controller.enable_detection(enemy, type, select) }

        Then { at.should have_received(:config).with("detect:enemy_colors", enemy.to_s) }
        Then { at.should have_received(:config).with("detect:detect_type", type.to_s) }
        Then { at.should have_received(:config).with("detect:detections_select_h", select.to_s) }
      end

      context "when setting with only enemy" do
        Given(:enemy)  { 2 }
        Given(:type)   { 10 }
        Given(:select) { 32 }

        When(:result) { controller.enable_detection(enemy) }

        Then { at.should have_received(:config).with("detect:enemy_colors", enemy.to_s) }
        Then { at.should have_received(:config).with("detect:detect_type", type.to_s) }
        Then { at.should have_received(:config).with("detect:detections_select_h", select.to_s) }
      end

      context "when doing demo mode" do
        When(:result) { controller.demo_mode }
        Then { at.should have_received(:config).with("general:navdata_demo", "TRUE") }
      end

      context "when selecting the forward camera" do
        When(:result) { controller.front_camera }
        Then { at.should have_received(:config).with("video:video_channel", "2") }
      end

      context "when selecting the bottom camera" do
        When(:result) { controller.bottom_camera }
        Then { at.should have_received(:config).with("video:video_channel", "1") }
      end

    end

    describe "reset watchdog command" do
      When(:result) { controller.reset_watchdog}
      Then { at.should have_received(:comwdg).with() }
    end

    describe "ack control mode command" do
      When(:result) { controller.ack_control_mode }
      Then { at.should have_received(:ctrl).with(5) }
    end
  end

end
