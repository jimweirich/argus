require 'thread'

module Argus
  class ATCommander
    attr_reader :timestamps

    def initialize(sender)
      @sender = sender
      @seq = 0
      @ref_data = "0"
      @pcmd_data = "0,0,0,0,0"
      @buffer = ""
      @thread = nil
      @interval = 0.020
      @mutex = Mutex.new
      @timestamps = []
    end

    def start
      @running = true
      @thread = Thread.new do
        while @running
          log_time
          tick
          sleep @interval
        end
      end
    end

    def tick
      @mutex.synchronize do
        packet do
          command("REF", @ref_data)
          command("PCMD", @pcmd_data)
        end
      end
    end

    def stop
      @running = false
    end

    def join
      @thread.join if @thread
    end

    def interval=(new_interval)
      @mutex.synchronize do @interval = new_interval end
    end

    def ref(data)
      @mutex.synchronize do @ref_data = data end
    end

    def pcmd(data)
      @mutex.synchronize do @pcmd_data = data end
    end

    def config(key, value)
      @mutex.synchronize do
        command("CONFIG", "\"#{key}\",\"#{value}\"")
      end
    end

    def comwdg
      @mutex.synchronize do
        command("COMWDG")
      end
    end
    alias reset_watchdog comwdg # For backward compatibility

    def ctrl(mode)
      @mutex.synchronize do
        command("CTRL", "#{mode},0")
      end
    end

    private

    def log_time
      @timestamps.shift if @timestamps.size >= 1000
      @timestamps <<  Time.now.to_f
    end

    def packet
      yield self
      flush
    end

    def flush
      @sender.send_packet(@buffer)
      @buffer = ""
    end

    def command(name, args=nil)
      @seq += 1
      if args
        @buffer << "AT*#{name}=#{@seq},#{args}\r"
      else
        @buffer << "AT*#{name}=#{@seq}\r"
      end
    end
  end
end
