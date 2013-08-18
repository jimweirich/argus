require 'socket'

module Argus
  class VideoStreamer
    attr_reader :tcp_socket, :host, :port
    
    def initialize(opts={})
      @host = opts[:host] || '192.168.1.1'
      @port = opts[:port] || 5555
      @tcp_socket = opts[:socket] || TCPSocket.new(@host, @port)
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
