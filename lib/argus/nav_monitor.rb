module Argus

  class NavMonitor
    def initialize(controller)
      @controller = controller
      @nav = NavStreamer.new
      @nav_callback = nil
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

    def callback(&block)
      @callback = block
    end

    def data
      @mutex.synchronize { @nav_data }
    end

    def option(tag)
      @mutex.synchronize { @nav_options[tag] }
    end

    private

    def update_nav_data(data)
      update_internal_nav_data(data)
      do_callbacks(data)
    end

    def update_internal_nav_data(data)
      @mutex.synchronize do
        @nav_data = data
        if @nav_data.bootstrap?
          @controller.demo_mode
        end
        data.options.each do |opt|
          @nav_options[opt.tag] = opt if opt.tag < 100
        end
      end
    end

    def do_callbacks(data)
      @callback.call(data) if data && @callback
    end
  end

end
