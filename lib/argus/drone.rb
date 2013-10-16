require 'socket'
require 'argus/nav_monitor'

module Argus

  class Drone
    attr_reader :controller, :nav

    def initialize(opts={})
      host = opts[:remote_host] || '192.168.1.1'
      port = opts[:post] || '5556'
      @sender = opts[:sender] || Argus::UdpSender.new(socket: opts[:socket], remote_host: host, port: port)
      @at = opts[:commander] || Argus::ATCommander.new(@sender)
      @controller = opts[:controller] || Argus::Controller.new(@at)
      if opts[:nav_monitor]
        @nav = opts[:nav_monitor]
      elsif opts.fetch(:enable_nav_monitor, true)
        @nav =  NavMonitor.new(@controller, host)
      else
        @nav = NullNavMonitor.new
      end
    end

    def commander
      @at
    end

    def start(enable_nav_monitor=true)
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
       take_off land hover disable_emergency enable_emergency
       forward backward
       left right
       up down
       turn_left turn_right
       front_camera bottom_camera
       config
       led animate
       reset_watchdog
    ).each do |meth|
      define_method(meth) { |*args|
        @controller.send(meth, *args)
      }
    end

  end
end
