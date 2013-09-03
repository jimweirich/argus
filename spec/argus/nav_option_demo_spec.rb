require 'spec_helper'
require 'base64'

module Argus
  describe NavOptionDemo do
    def f(float)
      FloatEncoding.encode_float(float)
    end

    # NOTE: This is a Base 64 encoded NavData packet recorded directly from the drone.
    Given(:base64_data) {
      "iHdmVdAEgA/5iwAAAAAAAAAAlAAAAAIAPAAAAADwREUAgCNFQFEiyAAAAABk" +
      "AAAAZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0AAADWP3i/6kNxPniCg72IpXO+64R4" +
      "v+kAAD2hLGG9u7U6PatYfz8AAAAAAAAAAAAAdcMQAEgBAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8I" +
      "ANQdAAA="
    }
    Given(:raw_data) { Base64.decode64(base64_data) }
    Given(:nav_data) { NavData.new(raw_data) }

    When(:demo) { nav_data.options.first }

    Then { ! demo.nil? }
    Then { demo.tag == Argus::NavTag::DEMO }
    Then { demo.size == 148 }

    Then { demo.ctrl_state == 0x20000 }
    Then { demo.control_state_name == :default }
    Then { demo.vbat_flying_percentage == 60 }
    Then { demo.battery_level == 60 }
    Then { demo.theta == 3151.0 }
    Then { demo.phi == 2616.0 }
    Then { demo.psi == -166213.0 }
    Then { demo.pitch == 3.151 }
    Then { demo.roll == 2.616 }
    Then { demo.yaw == -166.213 }
    Then { demo.altitude == 0 }
    Then { demo.vx == about(0).delta(0.00000001) }
    Then { demo.vy == about(0).delta(0.00000001) }
    Then { demo.vz == about(0).delta(0.00000001) }
    Then { demo.detection_camera_rot }
    Then { demo.detection_camera_trans }
    Then { demo.detection_tag_index == 0 }
    Then { demo.detection_camera_type == 13 }
    Then { demo.drone_camera_rot }
    Then { demo.drone_camera_trans }
  end

end
