module Argus
  module CadType

    NAMES = [
      :horizontal,              # Deprecated
      :vertical,                # Deprecated
      :vision,                  # Detection of 2D horizontal tags on drone shells
      :none,                    # Detection disabled
      :cocarde,                 # Detects a roundel under the drone
      :oriented_cocarde,        # Detects an oriented roundel under the drone
      :stripe,                  # Detects a uniform stripe on the ground
      :h_cocarde,               # Detects a roundel in front of the drone
      :h_oriented_cocarde,      # Detects an oriented roundel in front of the drone
      :stripe_v,
      :multiple_detection_mode, # The drone uses several detections at the same time
      :cap,                     # Detects a Cap orange and green in front of the drone
      :oriented_cocarde_bw,     # Detects the black and white roundel
      :vision_v2,               # Detects 2nd version of shell/tag in front of the drone
      :tower_side,              # Detect a tower side with the front camera
    ]
  end
end
