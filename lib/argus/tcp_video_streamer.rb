require 'socket'
module Argus
  class TcpVideoStreamer
    def initialize(tcp_socket, host=nil, port=nil)
      @tcp_socket = tcp_socket
      @host = host || '192.168.1.1'
      @port = port || 5555
    end

    def start_stream
      sock = UDPSocket.new
      sock.send("\x01\x00\x00\x00",0,@host,@port)
      sock.close
    end

    def read(n)
      @tcp_socket.read(n)
    end
  end
end
