require 'spec_helper'

module Argus
  describe VideoStreamer do
    Given(:tcp_socket) { flexmock("Socket", send: nil).should_ignore_missing }
    Given(:streamer) { VideoStreamer.new(tcp_socket) }

    context "starting the stream" do
      Given(:udp_socket) { flexmock("Socket", send: nil).should_ignore_missing }
      When { streamer.start(udp_socket) }
      Then { udp_socket.should have_received(:send) }
      Then { udp_socket.should have_received(:close) }
    end

    pending "when receiving good data"
    pending "when receiving bad data"
  end
end
