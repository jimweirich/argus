module Argus

  class NullNavMonitor
    UsageError = Class.new(StandardError)
    def callback(*)
      fail UsageError, "Callbacks are not supported when the NavMonitor is disabled."
    end
    def method_missing(*)
      # Noop
    end
  end

end
