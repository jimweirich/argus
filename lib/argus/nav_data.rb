module Argus
  class NavData
    attr_accessor :drone_state, :options, :vision_flag, :sequence_number
    def initialize(data)
      @data = data
      parse_nav_data(@data)
    end

    private 
    def parse_nav_data(data)
      state = data.unpack("V").first
      @drone_state = {
        :flying=>state[0],  #/*!< FLY MASK : (0) ardrone is landed, (1) ardrone is flying */
        :videoEnabled=>state[1],  #/*!< VIDEO MASK : (0) video disable, (1) video enable */
        :visionEnabled=>state[2],  #/*!< VISION MASK : (0) vision disable, (1) vision enable */
        :controlAlgorithm=>state[3],  #/*!< CONTROL ALGO : (0) euler angles control, (1) angular speed control */
        :altitudeControlAlgorithm=>state[4],  #/*!< ALTITUDE CONTROL ALGO : (0) altitude control inactive (1) altitude control active */
        :startButtonState=>state[5],  #/*!< USER feedback : Start button state */
        :controlCommandAck=>state[6],  #/*!< Control command ACK : (0) None, (1) one received */
        :cameraReady=>state[7],  #/*!< CAMERA MASK : (0) camera not ready, (1) Camera ready */
        :travellingEnabled=>state[8],  #/*!< Travelling mask : (0) disable, (1) enable */
        :usbReady=>state[9],  #/*!< USB key : (0) usb key not ready, (1) usb key ready */
        :navdataDemo=>state[10], #/*!< Navdata demo : (0) All navdata, (1) only navdata demo */
        :navdataBootstrap=>state[11], #/*!< Navdata bootstrap : (0) options sent in all or demo mode, (1) no navdata options sent */
        :motorProblem=>state[12], #/*!< Motors status : (0) Ok, (1) Motors problem */
        :communicationLost=>state[13], #/*!< Communication Lost : (1) com problem, (0) Com is ok */
        :softwareFault=>state[14], #/*!< Software fault detected - user should land as quick as possible (1) */
        :lowBattery=>state[15], #/*!< VBat low : (1) too low, (0) Ok */
        :userEmergencyLanding=>state[16], #/*!< User Emergency Landing : (1) User EL is ON, (0) User EL is OFF*/
        :timerElapsed=>state[17], #/*!< Timer elapsed : (1) elapsed, (0) not elapsed */
        :MagnometerNeedsCalibration=>state[18], #/*!< Magnetometer calibration state : (0) Ok, no calibration needed, (1) not ok, calibration needed */
        :anglesOutOfRange=>state[19], #/*!< Angles : (0) Ok, (1) out of range */
        :tooMuchWind=>state[20], #/*!< WIND MASK: (0) ok, (1) Too much wind */
        :ultrasonicSensorDeaf=>state[21], #/*!< Ultrasonic sensor : (0) Ok, (1) deaf */
        :cutoutDetected=>state[22], #/*!< Cutout system detection : (0) Not detected, (1) detected */
        :picVersionNumberOk=>state[23], #/*!< PIC Version number OK : (0) a bad version number, (1) version number is OK */
        :atCodecThreadOn=>state[24], #/*!< ATCodec thread ON : (0) thread OFF (1) thread ON */
        :navdataThreadOn=>state[25], #/*!< Navdata thread ON : (0) thread OFF (1) thread ON */
        :videoThreadOn=>state[26], #/*!< Video thread ON : (0) thread OFF (1) thread ON */
        :acquisitionThreadOn=>state[27], #/*!< Acquisition thread ON : (0) thread OFF (1) thread ON */
        :controlWatchdogDelay=>state[28], #/*!< CTRL watchdog : (1) delay in control execution (> 5ms), (0) control is well scheduled */
        :adcWatchdogDelay=>state[29], #/*!< ADC Watchdog : (1) delay in uart2 dsr (> 5ms), (0) uart2 is good */
        :comWatchdogProblem=>state[30], #/*!< Communication Watchdog : (1) com problem, (0) Com is ok */
        :emergencyLanding=>state[31]  #/*!< Emergency landing : (0) no emergency, (1) emergency */
      }
      data.slice!(0..3)
      @sequence_number = data.unpack("V").first
      data.slice!(0..3)
      @vision_flag = data.unpack("V").first
      @options = []
      option1 = {}
      data.slice!(0..3)
      option1[:id] = data.unpack("v").first
      data.slice!(0..1)
      option1[:size] = data.unpack("v").first
      data.slice!(0..1)
      option1[:data] = data.unpack("V").first
      @options.push(option1)
    end
  end
end
