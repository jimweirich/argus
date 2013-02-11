require 'socket'

module Argus
  class NavStreamer 
    def initialize
      @streamer = Argus::UdpNavStreamer.new(UDPSocket.new)
    end

    def start
      @streamer.start_stream
    end

    def recieve
      @streamer.recieve_packet
    end
  end
end
