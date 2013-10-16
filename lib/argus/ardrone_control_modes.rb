module Argus
  module ArdroneControlModes
    # ARDRONE_CONTROL_MODE values from the ardrone_api.h file.

    CFG_GET_CONTROL_MODE        = 4 # Send active configuration file
                                    # to a client through the
                                    # 'control' socket UDP 5559

    ACK_CONTROL_MODE            = 5 # Reset command mask in navdata

    CUSTOM_CFG_GET_CONTROL_MODE = 6 # Requests the list of custom
                                    # configuration IDs
  end
end
