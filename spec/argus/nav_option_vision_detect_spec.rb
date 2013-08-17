require 'spec_helper'

module Argus

  describe NavOptionVisionDetect do
    def f(float)
      FloatEncoding.encode_float(float)
    end

    Given(:raw_data) {
      [
        NavTag::VISION_DETECT, 328,
        2,
        1, 2, 3, 4,
        10, 11, 12, 13,
        20, 21, 22, 23,
        30, 31, 32, 33,
        40, 41, 42, 43,
        50, 51, 52, 53,
        f(60.0), f(61.0), f(62.0), f(63.0),
        0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,
        0,0,0, 0,0,0, 0,0,0, 0,0,0,
        70, 71, 72, 73
      ].flatten.pack("vv V V4 V4 V4 V4 V4 V4 V4 V36 V12 V4")
    }

    When(:detect) { NavOptionVisionDetect.new(raw_data) }

    Then { NavOptionVisionDetect.tag == NavTag::VISION_DETECT }
    Then { detect.tag == Argus::NavTag::VISION_DETECT }
    Then { detect.size == 328 }

    describe "C fields" do
      Then { detect.nb_detected == 2 }
      Then { detect.type == [1, 2, 3, 4] }
      Then { detect.type_name == [:vertical, :vision, :none, :cocarde] }
      Then { detect.xc == [10, 11, 12, 13] }
      Then { detect.yc == [20, 21, 22, 23] }
      Then { detect.width == [30, 31, 32, 33] }
      Then { detect.height == [40, 41, 42, 43] }
      Then { detect.dist == [50, 51, 52, 53] }
      Then { detect.distance == [50, 51, 52, 53] }
      Then { detect.orientation_angle == [60.0, 61.0, 62.0, 63.0] }
      Then { detect.rotation.size == 4 }
      Then { detect.translation.size == 4 }
      Then { detect.camera_source == [70, 71, 72, 73] }
    end

    describe "detection info" do
      Then { detect.detections.size == 2 }

      let(:d0) { detect.detections[0] }
      Then { d0.type == 1 }
      Then { d0.type_name == :vertical }
      Then { d0.x == 10 }
      Then { d0.y == 20 }
      Then { d0.width == 30 }
      Then { d0.height == 40 }
      Then { d0.orientation_angle == 60.0 }
      Then { d0.camera_source == 70 }
    end

  end

end
