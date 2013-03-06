module Argus

  class NavOptionUnknown < NavOption
    attr_reader :tag

    def initialize(raw_data)
      @tag, @size = raw_data.unpack("vv")
    end

    def self.tag
      0xfffe
    end
  end

end
