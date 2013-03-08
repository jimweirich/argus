module Argus

  class NavMonitor
    def initialize(controller)
      @controller = controller
      @nav = NavStreamer.new
      @callbacks = []
      @mutex = Mutex.new
      @nav_data = nil
      @nav_options = {}
    end

    def start
      @nav.start
      @running = true
      @nav_thread = Thread.new do
        while @running
          data = @nav.receive_data
          update_nav_data(data) if data
        end
      end
    end

    def stop
      @running = false
    end

    def join
      @nav_thread.join
    end

    def callback(callback=nil, &block)
      @mutex.synchronize do
        @callbacks << callback unless callback.nil?
        @callbacks << block if block_given?
      end
    end

    def data
      @mutex.synchronize { @nav_data }
    end

    def option(tag)
      @mutex.synchronize { @nav_options[tag] }
    end

    private

    def update_nav_data(data)
      @mutex.synchronize do
        update_internal_nav_data(data)
        do_callbacks(data)
      end
    rescue Exception => ex
      puts "ERROR in callback: #{ex}"
      puts ex.message
      $stdout.flush
    end

    def update_internal_nav_data(data)
      @nav_data = data
      if @nav_data.bootstrap?
        @controller.demo_mode
      end
      data.options.each do |opt|
        @nav_options[opt.tag] = opt if opt.tag < 100
      end
    end

    def do_callbacks(data)
      @callbacks.each do |callback|
        callback.call(data)
      end
    end
  end

end
