require 'socket'

module Argus
  class NavStreamer
    def initialize(socket=nil, host='192.168.1.1', port='5554')
      # TODO: Why is the port a string?
      @socket = socket || UDPSocket.new
      @host = host
      @port = port
      @socket.bind("0.0.0.0", port)
    end

    def start
      @socket.send("\x01\x00\x00\x00", 0, @host, @port)
    end

    def receive_data
      data, from = @socket.recvfrom(1024)
      if data.unpack("V").first == 0x55667788
        NavData.new(data)
      else
        nil
      end
    end
  end
end
