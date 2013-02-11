module Argus
  class UdpNavStreamer
    def initialize(udp_socket, host=nil, port=nil)
      @udp_socket = udp_socket
      @host = host || '192.168.1.1'
      @port = port || 5554
      @udp_socket.bind( "0.0.0.0", 5554)
    end

    def start_stream
      @udp_socket.send("\x01\x00\x00\x00",0,@host,@port)
    end

    def recieve_packet
      data, from = @udp_socket.recvfrom(1024)
      if data.unpack("V").first == "0x55667788".hex
        data.slice!(0..3)
        return NavData.new(data)
      else
        return "Not nav data!"
      end
    end
  end
end
