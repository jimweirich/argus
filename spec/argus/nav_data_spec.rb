require 'spec_helper'

module Bytes
  module_function

  def int32(n)
    [n].pack("V").unpack("C*")
  end

  def make_nav_data(*options)
    result = [Bytes.int32(0x55667788) + options].flatten
    add_checksum(result)
    result.pack("C*")
  end

  def make_header(state_bits, seq_number, vision_flag)
    Bytes.int32(state_bits) + Bytes.int32(seq_number) + Bytes.int32(vision_flag)
  end

  def add_checksum(bytes)
    [0xff, 0xff, 0x08, 0x00, 0x61, 0x04, 0x00, 0x00].each do |b| bytes << b end
    bytes
  end
end

module Argus
  describe NavData do
    Given(:state_bits) { 0xcf8a0c94 }
    Given(:seq_num) { 173064 }
    Given(:vision_flag) { 0 }
    Given(:raw_header) { Bytes.make_header(state_bits, seq_num, vision_flag) }
    Given(:raw_nav_bytes) { Bytes.make_nav_data(raw_header) }
    Given(:nav_data) { NavData.new(raw_nav_bytes) }

    Then { nav_data.sequence_number == 173064 }
    Then { nav_data.vision_flag == 0 }

    describe "sequence number" do
      Given(:seq_num) { 1234 }
      Then { nav_data.sequence_number == 1234 }
    end

    describe "vision flag" do
      Given(:vision_flag) { 1 }
      Then { nav_data.vision_flag == 1 }
    end

    describe "state queries" do

      def bit(n)
        0x00000001 << n
      end

      # Matcher for handling the mask testing for the state mask.
      #
      # Usage:
      #    bit(5).should be_the_mask_for(:method [, off_value, on_value])
      #
      # If off_value and on_value are not given, then false/true will
      # be assumed.
      #
      matcher :be_the_mask_for do |method, off_result=false, on_result=true|
        match do |mask|
          @msg = "OK"
          try_alternative(method, 0, off_result) &&
            try_alternative(method, mask, on_result)
        end

        failure_message_for_should do |mask|
          @msg
        end

        # Try one of the alternatives. Sending method to the navdata
        # constructed with mask should return teh expected value.
        def try_alternative(method, mask, expected)
          raw = Bytes.make_nav_data(Bytes.make_header(mask, 1, 0))
          nav_data = NavData.new(raw)
          result = nav_data.send(method)
          return true if result == expected
          @msg = "expected mask of 0x#{'%08x' % mask} with #{method}\n" +
            "to return: #{expected.inspect}\n" +
            "got:       #{result.inspect}"
          false
        end
      end

      Then { bit(0).should be_the_mask_for(:flying?) }
      Then { bit(1).should be_the_mask_for(:video_enabled?) }
      Then { bit(2).should be_the_mask_for(:vision_enabled?) }
      Then { bit(3).should be_the_mask_for(:control_algorithm, :euler, :angular_speed) }

      Then { bit(4).should be_the_mask_for(:altitude_control_algorithm_active?) }
      Then { bit(5).should be_the_mask_for(:start_button_pressed?) }
      Then { bit(6).should be_the_mask_for(:control_command_ack?) }
      Then { bit(7).should be_the_mask_for(:camera_ready?) }

      Then { bit(8).should be_the_mask_for(:travelling_enabled?) }
      Then { bit(9).should be_the_mask_for(:usb_ready?) }
      Then { bit(10).should be_the_mask_for(:mode, :all, :demo) }
      Then { bit(11).should be_the_mask_for(:bootstrap?) }

      Then { bit(12).should be_the_mask_for(:moter_problem?) }
      Then { bit(13).should be_the_mask_for(:communication_lost?) }
      Then { bit(14).should be_the_mask_for(:software_fault?) }
      Then { bit(15).should be_the_mask_for(:low_battery?) }

      Then { bit(16).should be_the_mask_for(:emergency_landing_requested?) }
      Then { bit(17).should be_the_mask_for(:timer_elapsed?) }
      Then { bit(18).should be_the_mask_for(:magnometer_needs_calibration?) }
      Then { bit(19).should be_the_mask_for(:angles_out_of_range?) }

      Then { bit(20).should be_the_mask_for(:too_much_wind?) }
      Then { bit(21).should be_the_mask_for(:ultrasonic_sensor_deaf?) }
      Then { bit(22).should be_the_mask_for(:cutout_detected?) }
      Then { bit(23).should be_the_mask_for(:pic_version_number_ok?) }

      Then { bit(24).should be_the_mask_for(:at_codec_thread_on?) }
      Then { bit(25).should be_the_mask_for(:navdata_thread_on?) }
      Then { bit(26).should be_the_mask_for(:video_thread_on?) }
      Then { bit(27).should be_the_mask_for(:acquisition_thread_on?) }

      Then { bit(28).should be_the_mask_for(:control_watchdog_delayed?) }
      Then { bit(29).should be_the_mask_for(:adc_watchdog_delayed?) }
      Then { bit(30).should be_the_mask_for(:com_watchdog_problem?) }
      Then { bit(31).should be_the_mask_for(:emergency_landing?) }
    end

    describe "state mask" do
      context "all zeros" do
        Given(:state_bits) { 0 }
        Then { nav_data.state_mask == state_bits }
      end

      context "non-zero" do
        Given(:state_bits) { 12345 }
        Then { nav_data.state_mask == state_bits }
      end
    end

    Then { nav_data.options.size == 1 }

  end
end
