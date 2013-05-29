require 'socket'
require 'argus/nav_monitor'

module Argus

  class Drone
    attr_reader :controller, :nav

    def initialize(socket=nil, host='192.168.1.1', port='5556')
      @socket = socket || UDPSocket.new
      @sender = Argus::UdpSender.new(@socket, host, port)
      @at = Argus::ATCommander.new(@sender)
      @controller = Argus::Controller.new(@at)
      @nav = NavMonitor.new(@controller)
    end

    def commander
      @at
    end

    def start
      @nav.start
      @at.start
    end

    def stop
      @controller.land

      @at.stop
      @nav.stop

      @at.join
      @nav.join
    end

    def nav_callback(*args, &block)
      @nav.callback(*args, &block)
    end

    %w(
       take_off land hover emergency
       forward backward
       left right
       up down
       turn_left turn_right
       front_camera bottom_camera
       config
       reset_watchdog
    ).each do |meth|
      define_method(meth) { |*args|
        @controller.send(meth, *args)
      }
    end

  end
end
