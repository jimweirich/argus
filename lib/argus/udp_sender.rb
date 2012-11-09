module Argus
  class UdpSender
    def initialize(udp_socket, host=nil, port=nil)
      @udp_socket = udp_socket
      @host = host || '192.168.1.1'
      @port = port || 5556
    end

    def send_packet(data)
      @udp_socket.send(data, 0, @host, @port)
    end
  end
end
