require 'socket'

module Argus

  # NavStreamer State Transitions:
  #
  # State    Trigger         Next  Action
  # ------   --------------  ----  -----------------
  # init     start           wait  reconnect
  #
  # wait     short_timeout   wait  request_nav_data
  # wait     long_timeout    wait  reconnect
  # wait     received_data   run   --
  #
  # run      short_timeout   run   --
  # run      long_timeout    wait  reconnect
  # run      received_data   run   --

  class NavStreamer
    attr_reader :state

    def initialize(opts={})
      @state = :init
      @socket = nil
      @remote_host  = opts.fetch(:remote_host)
      @local_host   = opts[:local_host]  || '0.0.0.0'
      @port         = opts[:port]        || 5554
      @socket_class = opts[:UDPSocket]   || UDPSocket
      start_timer
    end

    def start
      @state = :wait
      reconnect
    end

    def short_timeout
      if state == :wait
        request_nav_data
      end
    end

    def long_timeout
      if @state == :wait || @state == :run
        @state = :wait
        reconnect
      end
    end

    def receive_data
     data, from = @socket.recvfrom(1024)
      if data.unpack("V").first == 0x55667788
        received_data
        NavData.new(data)
      else
        nil
      end
    end

    def received_data
      if state == :wait || state == :run
        @state = :run
        @long_flag = false
        @short_flag = false
      end
    end

    private

    def request_nav_data
      @socket.send("\x01\x00\x00\x00", 0, @remote_host, @port)
    end

    def reconnect
      disconnect if @socket
      @socket = new_socket
      @socket.bind(@local_host, @port) rescue nil
      request_nav_data
    end

    def disconnect
      @socket.close
      @socket = nil
    end

    def new_socket
      @socket_class.new
    end

    def tick
      short_timeout if @short_flag
      @short_flag = true
      if @n == 0
        long_timeout if @long_flag
        @long_flag = true
      end
      @n += 1
      @n = 0 if @n == 10
    end

    def start_timer
      @n = 0
      @thread = Thread.new do
        loop do
          tick
          sleep 1.0
        end
      end
    end
  end
end
