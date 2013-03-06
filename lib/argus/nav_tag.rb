module Argus
  module NavTag
    DEMO,
    TIME,
    RAW_MEASURES,
    PHYS_MEASURES,
    GYROS_OFFSETS,
    EULER_ANGLES,
    REFERENCES,
    TRIMS,
    RC_REFERENCES,
    PWM,
    ALTITUDE,
    VISION_RAW,
    VISION_OF,
    VISION,
    VISION_PERF,
    TRACKERS_SEND,
    VISION_DETECT,
    WATCHDOG,
    ADC_DATA_FRAME,
    VIDEO_STREAM,
    GAMES,
    PRESSURE_RAW,
    MAGNETO,
    WIND,
    KALMAN_PRESSURE,
    HDVIDEO_STREAM,
    WIFI = (0..100).to_a

    CHECKSUM = 0xffff
    UNKNOWN  = 0xfffe           # Not part of the AR Drone DSK, Only used in Argus
  end

end
