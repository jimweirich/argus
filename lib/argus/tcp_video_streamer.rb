require 'socket'
module Argus
  class TcpVideoStreamer
    def initialize(tcp_socket=nil, host='192.168.1.1', port=5555)
      @tcp_socket = socket || TCPSocket.new(host, port)
      @host = host
      @port = port
    end

    def start_stream(udp_socket=nil)
      sock = udp_socket || UDPSocket.new
      sock.send("\x01\x00\x00\x00", 0, @host, @port)
      sock.close
    end

    def read(n)
      @tcp_socket.read(n)
    end
  end
end
