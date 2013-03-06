require 'argus/nav_option'

module Argus

  class NavOptionChecksum < NavOption
    attr_reader :tag, :checksum

    def initialize(raw_data)
      @tag, @size, @checksum = raw_data.unpack("vvV")
    end

    def self.tag
      0xffff
    end

    NavOption.register(self)
  end

end
