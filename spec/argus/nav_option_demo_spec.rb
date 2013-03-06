require 'spec_helper'

module Argus
  describe NavOptionDemo do
    def f(float)
      FloatEncoding.encode_float(float)
    end

    Given(:raw_data) { [
        0, 148,
        3, 0xcacacaca,
        f(5.0), f(6.0), f(7.0),
        -100000,
        f(-5.0), f(-6.0), f(-7.0),
        33,
        [0]*9, [0]*3,
        12, 34,
        [0]*9, [0]*3,
      ].flatten.pack("vv VV V3 l< V3 V V9 V3 VV V9 v3") }

    When(:demo) { NavOptionDemo.new(raw_data) }

    Then { ! demo.nil? }

    Then { demo.ctrl_state == 3 }
    Then { demo.control_state_name == :flying }
    Then { demo.vbat_flying_percentage == 0xcacacaca }
    Then { demo.theta == 5.0 }
    Then { demo.phi == 6.0 }
    Then { demo.psi == 7.0 }
    Then { demo.altitude == -100000 }
    Then { demo.vx == -5.0 }
    Then { demo.vy == -6.0 }
    Then { demo.vz == -7.0 }
    Then { demo.detection_camera_rot.nil? }
    Then { demo.detection_camera_trans.nil? }
    Then { demo.detection_tag_index == 12 }
    Then { demo.detection_camera_type == 34 }
    Then { demo.drone_camera_rot.nil? }
    Then { demo.drone_camera_trans.nil? }
  end

end
