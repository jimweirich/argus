require 'spec_helper'

module Argus
  describe NavStreamer do
    Given(:remote_host) { '192.168.1.1' }
    Given(:port) { 5554 }
    Given(:socket) { flexmock("Socket", send: nil).should_ignore_missing }
    Given(:streamer) { NavStreamer.new(UDPSocket: flexmock(new: socket)) }

    context "after starting" do
      Given { streamer.start }

      context "when receiving good data" do
        Given(:bytes) { Bytes.make_nav_data(Bytes.make_header(0x1234, 0, 0)) }
        Given { socket.should_receive(recvfrom: bytes) }
        When(:nav_data) { streamer.receive_data }
        Then { nav_data.state_mask == 0x1234}
      end

      context "when receiving bad data" do
        Given(:bytes) { [0x89, 0x77, 0x66, 0x55, 0x34, 0x12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].pack("C*") }
        Given { socket.should_receive(:recvfrom => bytes) }
        When(:nav_data) { streamer.receive_data }
        Then { nav_data.nil? }
      end
    end

    describe "State Transitions" do
      Given {
        flexmock(streamer, reconnect: nil, request_nav_data: nil)
      }

      def goto_wait
        streamer.start
      end

      def goto_run
        streamer.start
        streamer.received_data
      end

      context "when init & start" do
        Given { streamer.start }
        Then { streamer.should have_received(:reconnect).once }
        Then { streamer.state == :wait }
      end

      context "when init & short_timeout" do
        Given { streamer.short_timeout }
        Then { streamer.should have_received(:reconnect).never }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :init }
      end

      context "when init & long_timeout" do
        Given { streamer.long_timeout }
        Then { streamer.should have_received(:reconnect).never }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :init }
      end

      context "when wait & received_data" do
        Given { goto_wait }
        Given { streamer.received_data }
        Then { streamer.should have_received(:reconnect).once }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :run }
      end

      context "when wait & short_timeout" do
        Given { goto_wait }
        Given { streamer.short_timeout }
        Then { streamer.should have_received(:reconnect).once }
        Then { streamer.should have_received(:request_nav_data).once }
        Then { streamer.state == :wait }
      end

      context "when wait & long_timeout" do
        Given { goto_wait }
        Given { streamer.long_timeout }
        Then { streamer.should have_received(:reconnect).twice }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :wait }
      end

      context "when run & received_data" do
        Given { goto_run }
        Given { streamer.received_data }
        Then { streamer.should have_received(:reconnect).once }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :run }
      end

      context "when run & short_timeout" do
        Given { goto_run }
        Given { streamer.short_timeout }
        Then { streamer.should have_received(:reconnect).once }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :run }
      end

      context "when run & long_timeout" do
        Given { goto_run }
        Given { streamer.long_timeout }
        Then { streamer.should have_received(:reconnect).twice }
        Then { streamer.should have_received(:request_nav_data).never }
        Then { streamer.state == :wait }
      end
    end
  end
end
