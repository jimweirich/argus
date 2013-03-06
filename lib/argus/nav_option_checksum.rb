require 'argus/cfields'
require 'argus/nav_option'
require 'argus/nav_tag'

module Argus

  class NavOptionChecksum < NavOption
    include CFields

    uint32_t :chks
    alias :checksum :chks

    def self.tag
      NavTag::CHECKSUM
    end

    NavOption.register(self)
  end

end
