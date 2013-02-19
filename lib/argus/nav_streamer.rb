require 'socket'

module Argus
  class NavStreamer 
    def initialize(socket=nil, host='192.168.1.1', port='5554')
      @socket = socket || UDPSocket.new
      @streamer = Argus::UdpNavStreamer.new(@socket, host, port)
    end

    def start
      @streamer.start_stream
    end

    def receive_data
      @streamer.receive_packet
    end
  end
end
