require 'argus/cfields'
require 'argus/float_encoding'
require 'argus/nav_option'
require 'argus/nav_tag'

module Argus

  class NavOptionDemo < NavOption
    include CFields

    uint32_t :ctrl_state               # Flying state (landed, flying, hovering, etc.) defined in CTRL_STATES enum.
    uint32_t :vbat_flying_percentage   # battery voltage filtered (mV)

    float32_t :theta                   # UAV's pitch in milli-degrees
    float32_t :phi                     # UAV's roll  in milli-degrees
    float32_t :psi                     # UAV's yaw   in milli-degrees

    int32_t :altitude                  # UAV's altitude in centimeters

    float32_t :vx                      # UAV's estimated linear velocity
    float32_t :vy                      # UAV's estimated linear velocity
    float32_t :vz                      # UAV's estimated linear velocity

    uint32_t :num_frames               # streamed frame index // Not used -> To integrate in video stage.

    # Camera parameters compute by detection
    matrix33_t :detection_camera_rot   # Deprecated ! Don't use !
    vector31_t :detection_camera_trans # Deprecated ! Don't use !
    uint32_t :detection_tag_index      # Deprecated ! Don't use !

    uint32_t :detection_camera_type    #  Type of tag searched in detection

    # Camera parameters compute by drone
    matrix33_t :drone_camera_rot       # Deprecated ! Don't use !
    vector31_t :drone_camera_trans     # Deprecated ! Don't use !

    CONTROL_STATE_NAMES = [
      :default,
      :init,
      :landed,
      :flying,
      :hovering,
      :test,
      :trans_takeoff,
      :trans_gotofix,
      :trans_landing,
      :trans_looping,
    ]

    def control_state_name
      CONTROL_STATE_NAMES[ctrl_state]
    end

    def self.tag
      NavTag::DEMO
    end

    NavOption.register(self)
  end

end
