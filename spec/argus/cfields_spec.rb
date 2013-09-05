require 'spec_helper'

module CFieldsSpec
  describe Argus::CFields do
    class Example < Argus::NavOption
      include Argus::CFields
      uint32_t :u32
      uint16_t :u16
      float32_t :f32
      int32_t   :i32
      matrix33_t :m33
      vector31_t :v31

      def self.tag
        14263
      end

      Argus::NavOption.register(self)
    end

    Given(:raw_data) {
      [
        Bytes.int16(Example.tag),
        Bytes.int16(10),
        Bytes.int32(1),
        Bytes.int16(2),
        Bytes.float32(3.4),
      ].flatten.pack("C*")
    }

    When(:data) { Example.new(raw_data) }

    Then { data.size == 10 }
    Then { data.tag == Example.tag }
    Then { data.u32 == 1 }
    Then { data.u16 == 2 }
    Then { data.f32 == about(3.4).percent(1) }
  end
end
