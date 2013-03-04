require 'spec_helper'

module Argus
  describe NavData do
    Given(:raw_nav_bytes) { [148, 12, 138, 207, 8, 164, 2, 0, 0, 0, 0, 0, 255, 255, 8, 0, 97, 4, 0, 0] }
    Given(:raw_nav) { raw_nav_bytes.pack("C*") }
    Given(:nav_data) { NavData.new(raw_nav) }
    Given(:state) {
      {
        :flying=>0, :videoEnabled=>0, :visionEnabled=>1, :controlAlgorithm=>0,
        :altitudeControlAlgorithm=>1, :startButtonState=>0, :controlCommandAck=>0,
        :cameraReady=>1, :travellingEnabled=>0, :usbReady=>0, :navdataDemo=>1,
        :navdataBootstrap=>1, :motorProblem=>0, :communicationLost=>0,
        :softwareFault=>0, :lowBattery=>0, :userEmergencyLanding=>0, :timerElapsed=>1,
        :MagnometerNeedsCalibration=>0, :anglesOutOfRange=>1, :tooMuchWind=>0,
        :ultrasonicSensorDeaf=>0, :cutoutDetected=>0, :picVersionNumberOk=>1,
        :atCodecThreadOn=>1, :navdataThreadOn=>1, :videoThreadOn=>1,
        :acquisitionThreadOn=>1, :controlWatchdogDelay=>0, :adcWatchdogDelay=>0,
        :comWatchdogProblem=>1, :emergencyLanding=>1,
      }
    }
    Then { nav_data.drone_state == state }
  end
end
