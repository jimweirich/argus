require 'spec_helper'

module Argus

  describe NavOptionUnknown do
    Given(:raw_data) { [0x5231, 8, 0x12345678].pack("vvV") }
    Given(:opt) { NavOptionUnknown.new(raw_data) }

    describe ".tag" do
      Then { NavOptionUnknown.tag == 0xfffe }
    end

    describe "data fields" do
      Then { opt.tag == 0x5231 }
      Then { opt.size == raw_data.size }
    end
  end

end
