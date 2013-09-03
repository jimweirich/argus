require 'spec_helper'

describe Argus::ATCommander do
  Given(:sender) { flexmock(:on, Argus::UdpSender) }
  Given(:cmdr) { Argus::ATCommander.new(sender) }

  describe "#tick" do
    Given(:expected_commands) {
      [
        "AT\\*REF=\\d+,0",
        "AT\\*PCMD=\\d+,0,0,0,0,0",
      ]
    }
    Given(:command_pattern) { Regexp.new('\A' + expected_commands.map { |s| "#{s}\r" }.join + '\Z') }

    When { cmdr.send(:tick) }

    context "with no commands" do
      Then { sender.should have_received(:send_packet).with(command_pattern) }
    end

    context "with a ref command" do
      Given { expected_commands[0] = 'AT\*REF=\d+,512' }
      Given { cmdr.ref("512") }
      Then { sender.should have_received(:send_packet).with(command_pattern) }
    end

    context "with a pcmd command" do
      Given { expected_commands[1] = 'AT\*PCMD=\d+,1,2,3,4,5' }
      Given { cmdr.pcmd("1,2,3,4,5") }
      Then { sender.should have_received(:send_packet).with(command_pattern) }
    end

    context "with a config command" do
      Given { expected_commands.unshift('AT\*CONFIG=\d+,"general:navdata_demo","TRUE"') }
      Given { cmdr.config("general:navdata_demo", "TRUE") }
      Then { sender.should have_received(:send_packet).with(command_pattern) }
    end

    context "with a reset watchdog command" do
      Given { expected_commands.unshift('AT\*COMWDG=\d+') }
      Given { cmdr.comwdg }
      Then { sender.should have_received(:send_packet).with(command_pattern) }
    end

    context "with a contrl command" do
      Given { expected_commands.unshift('AT\*CTRL=\d+,4,0') }
      Given { cmdr.ctrl(4) }
      Then { sender.should have_received(:send_packet).with(command_pattern) }
    end
  end

  describe "increasing sequence numbers" do
    Given(:seq_numbers) { [ ] }
    Given {
      sender.should_receive(:send_packet).and_return { |data|
        data.scan(%r{=(\d+),}) { |seq|
          seq_numbers << seq.first.to_i }
      }
    }
    When { 2.times { cmdr.tick } }
    Then { seq_numbers.should == [1, 2, 3, 4] }
  end

  describe "sending thread" do
    Given {
      @count = 0
      sender.should_receive(:send_packet).and_return {
        @count += 1
        cmdr.stop if @count > 5
      }
    }
    When {
      cmdr.start
      cmdr.join
    }
    Then { sender.should have_received(:send_packet) }
  end



end
