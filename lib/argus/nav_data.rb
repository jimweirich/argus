module Argus
  class NavData
    attr_accessor :state_mask, :vision_flag, :sequence_number, :options

    def initialize(data)
      # puts "--RAW--"            # DBG:
      # puts data.inspect         # DBG:
      @data = data
      # puts "--PARSED--"         # DBG:
      parse_nav_data(@data)
        # .tap { |d| puts d.inspect } # DBG:
    end

    def self.bit_mask_readers(*names)
      names.each.with_index do |name, bit_number|
        if name.is_a?(Array)
          name, off_value, on_value = name
        else
          off_value = false
          on_value = true
        end
        define_method(name) { @state_mask[bit_number] == 0 ? off_value : on_value }
      end
    end

    bit_mask_readers(
      :flying?,                            # FLY MASK : (0) ardrone is landed, (1) ardrone is flying
      :video_enabled?,                     # VIDEO MASK : (0) video disable, (1) video enable
      :vision_enabled?,                    # VISION MASK : (0) vision disable, (1) vision enable
      [:control_algorithm,                 # CONTROL ALGO : (0) euler angles control, (1) angular speed control
        :euler, :angular_speed],
      :altitude_control_algorithm_active?, # ALTITUDE CONTROL ALGO : (0) altitude control inactive (1) altitude control active
      :start_button_pressed?,              # USER feedback : Start button state
      :control_command_ack?,               # Control command ACK : (0) None, (1) one received
      :camera_ready?,                      # CAMERA MASK : (0) camera not ready, (1) Camera ready
      :travelling_enabled?,                # Travelling mask : (0) disable, (1) enable
      :usb_ready?,                         # USB key : (0) usb key not ready, (1) usb key ready
      [:mode, :all, :demo],                # Navdata demo : (0) All navdata, (1) only navdata demo
      :bootstrap?,                         # Navdata bootstrap : (0) options sent in all or demo mode, (1) no navdata options sent
      :moter_problem?,                     # Motors status : (0) Ok, (1) Motors problem
      :communication_lost?,                # Communication Lost : (1) com problem, (0) Com is ok
      :software_fault?,                    # Software fault detected - user should land as quick as possible (1)
      :low_battery?,                       # VBat low : (1) too low, (0) Ok
      :emergency_landing_requested?,       # User Emergency Landing : (1) User EL is ON, (0) User EL is OF
      :timer_elapsed?,                     # Timer elapsed : (1) elapsed, (0) not elapsed
      :magnometer_needs_calibration?,      # Magnetometer calibration state : (0) Ok, no calibration needed, (1) not ok, calibration needed
      :angles_out_of_range?,               # Angles : (0) Ok, (1) out of range
      :too_much_wind?,                     # WIND MASK: (0) ok, (1) Too much wind
      :ultrasonic_sensor_deaf?,            # Ultrasonic sensor : (0) Ok, (1) deaf
      :cutout_detected?,                   # Cutout system detection : (0) Not detected, (1) detected
      :pic_version_number_ok?,             # PIC Version number OK : (0) a bad version number, (1) version number is OK
      :at_codec_thread_on?,                # ATCodec thread ON : (0) thread OFF (1) thread ON
      :navdata_thread_on?,                 # Navdata thread ON : (0) thread OFF (1) thread ON
      :video_thread_on?,                   # Video thread ON : (0) thread OFF (1) thread ON
      :acquisition_thread_on?,             # Acquisition thread ON : (0) thread OFF (1) thread ON
      :control_watchdog_delayed?,          # CTRL watchdog : (1) delay in control execution (> 5ms), (0) control is well scheduled
      :adc_watchdog_delayed?,              # ADC Watchdog : (1) delay in uart2 dsr (> 5ms), (0) uart2 is good
      :com_watchdog_problem?,              # Communication Watchdog : (1) com problem, (0) Com is ok
      :emergency_landing?)                 # Emergency landing : (0) no emergency, (1) emergency

    private

    def parse_nav_data(data)
      tag, @state_mask, @sequence_number, @vision_flag = data.unpack("VVVV")
      parse_nav_options(data[16..-1])
    end

    def parse_nav_options(data)
      @options = []
      loop do
        opt = NavOption.parse(data)
        data = data[opt.size .. -1]
        @options << opt
        break if opt.tag == 0xFFFF
      end
    end
  end
end
