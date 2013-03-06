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
      option = options[tag] || NavOptionUnknown
      option.new(raw_data)
    end

    def size
      @size < 4 ? 4 : @size
    end
  end

end
