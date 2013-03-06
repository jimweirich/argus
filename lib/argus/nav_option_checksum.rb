require 'argus/nav_option'

module Argus

  class NavOptionChecksum < NavOption
    attr_reader :checksum

    def initialize(raw_data)
      super
      @checksum = raw_data.unpack("x4V").first
    end

    def self.tag
      0xffff
    end

    NavOption.register(self)
  end

end
