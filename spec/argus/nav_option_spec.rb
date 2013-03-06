require 'spec_helper'

module Argus
  describe NavOption do
    let(:raw_checksum)      { [ NavTag::CHECKSUM, 8, 0x5555aaaa].pack("vvV") }
    let(:raw_demo)          { [ NavTag::DEMO, 148 ].pack("vv") + "\0" * 148 }
    let(:raw_vision_detect) { [ NavTag::VISION_DETECT, 328 ].pack("vv") + "\0" * 328 }
    let(:raw_unknown_tag)   { [ 12345, 8 ].pack("vv") + "    " }

    When(:result) { NavOption.parse(raw_data) }

    describe "parsing checksum options" do
      Given(:raw_data) { raw_checksum }
      Then { result.is_a?(NavOptionChecksum) }
    end

    describe "parsing demo option" do
      Given(:raw_data) { raw_demo }
      Then { result.is_a?(NavOptionDemo) }
    end

    describe "parsing vision detect option" do
      Given(:raw_data) { raw_vision_detect }
      Then { result.is_a?(NavOptionVisionDetect) }
    end

    describe "parsing bad tag" do
      Given(:raw_data) { raw_unknown_tag }
      Then { result.is_a?(NavOptionUnknown) }
    end
  end
end
