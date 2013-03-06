module Argus

  class NavOption
    def self.options
      @options ||= { }
    end

    def self.register(option)
      options[option.tag] = option
    end

    def self.parse(raw_data)
      tag = raw_data.unpack("v").first
      option = options[tag]
      raise Argus::InvalidNavDataError, "unrecognized tag #{tag}" if option.nil?
      option.new(raw_data)
    end
  end

end
