module Argus

  class NavOption
    attr_reader :tag

    def initialize(data)
      @tag, @size = data.unpack("vv")
    end

    def size
      @size < 4 ? 4 : @size
    end

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

    # Skip the tag and size fields, We've already handled them in the
    # base class.
    def self.initial_format
      "x4"
    end
  end

end
