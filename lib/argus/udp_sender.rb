module Argus
  class UdpSender
    def initialize(opts={})
      @udp_socket = opts[:socket] || UDPSocket.new
      @host = opts.fetch(:remote_host)
      @port = opts.fetch(:port, 5556)
    end

    def send_packet(data)
      @udp_socket.send(data, 0, @host, @port)
    end
  end
end
