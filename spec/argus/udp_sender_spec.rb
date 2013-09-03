require 'spec_helper'
require 'socket'

describe Argus::UdpSender do
  Given(:port) { '5500' }
  Given(:host) { 'localhost' }

  context "with real socket" do
    Given(:socket) { UDPSocket.new }
    Given(:sender) { Argus::UdpSender.new(remote_host: host, port: port) }
    Given!(:server) {
      server = UDPSocket.new
      server.bind(nil, port)
      Thread.new {
        @data, _ = server.recvfrom(1000)
      }
    }
    When {
      sender.send_packet("HI")
      server.join
    }
    Then { @data.should == "HI" }
  end

  context "with provided socket" do
    Given(:socket) { flexmock(send: nil) }
    Given(:sender) { Argus::UdpSender.new(socket: socket, remote_host: host, port: port) }

    When { sender.send_packet("HI") }

    Then { socket.should have_received(:send).with("HI", 0, host, port).once }
  end
end
