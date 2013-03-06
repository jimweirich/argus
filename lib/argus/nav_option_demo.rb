require 'argus/nav_option'

module Argus

  class NavOptionDemo < NavOption
    def initialize(raw_data)
      super
    end

    def self.tag
      0
    end

    NavOption.register(self)
  end

end
