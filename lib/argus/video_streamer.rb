require 'socket'

module Argus
  class VideoStreamer
    attr_reader :tcp_socket, :host, :port
    
    def initialize(tcp_socket=nil, host='192.168.1.1', port=5555)
      @tcp_socket = tcp_socket || TCPSocket.new(host, port)
      @host = host
      @port = port
    end

    def start(udp_socket=nil)
      @udp_socket = udp_socket || UDPSocket.new
      @udp_socket.send("\x01\x00\x00\x00", 0, host, port)
      @udp_socket.close
    end

    def receive_data
      VideoData.new(tcp_socket)
    end
  end
end
