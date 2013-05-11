require 'spec_helper'
require 'socket'

describe Argus::UdpSender do
  Given(:port) { '5500' }
  Given(:socket) { UDPSocket.new }
  Given(:sender) { Argus::UdpSender.new(socket, 'localhost', port) }
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
