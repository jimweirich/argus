require 'spec_helper'

module Argus
  describe UdpNavStreamer do
    Given(:socket) { flexmock("Socket", send: nil).should_ignore_missing }
    Given(:streamer) { UdpNavStreamer.new(socket) }

    context "starting the stream" do
      When { streamer.start_stream }
      Then { socket.should have_received(:bind).with(String, Integer) }
      Then { socket.should have_received(:send) }
    end

    context "when receiving good data" do
      Given(:bytes) { [0x88, 0x77, 0x66, 0x55, 0x34, 0x12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].pack("C*") }
      Given { socket.should_receive(:recvfrom => bytes) }
      When(:nav_data) { streamer.receive_packet }
      Then { nav_data.state_mask == 0x1234}
    end

    context "when receiving bad data" do
      Given(:bytes) { [0x89, 0x77, 0x66, 0x55, 0x34, 0x12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].pack("C*") }
      Given { socket.should_receive(:recvfrom => bytes) }
      When(:nav_data) { streamer.receive_packet }
      Then { nav_data.nil? }
    end
  end
end
