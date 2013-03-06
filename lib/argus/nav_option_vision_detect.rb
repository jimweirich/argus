require 'argus/cfields'
require 'argus/nav_tag'

module Argus

  class NavOptionVisionDetect < NavOption
    include CFields

    NB_NAVDATA_DETECTION_RESULTS = 4

    uint32_t   :nb_detected
    alias :detected_count :nb_detected
    uint32_t   :type, NB_NAVDATA_DETECTION_RESULTS
    uint32_t   :xc, NB_NAVDATA_DETECTION_RESULTS
    uint32_t   :yc, NB_NAVDATA_DETECTION_RESULTS
    uint32_t   :width, NB_NAVDATA_DETECTION_RESULTS
    uint32_t   :height, NB_NAVDATA_DETECTION_RESULTS
    uint32_t   :dist, NB_NAVDATA_DETECTION_RESULTS
    float32_t  :orientation_angle, NB_NAVDATA_DETECTION_RESULTS
    matrix33_t :rotation, NB_NAVDATA_DETECTION_RESULTS
    vector31_t :translation, NB_NAVDATA_DETECTION_RESULTS
    uint32_t   :camera_source, NB_NAVDATA_DETECTION_RESULTS

    class Detection
      def initialize(vision_detected, index)
        @vision_detected = vision_detected
        @index = index
      end

      def type
        @vision_detected.type[@index]
      end

      def type_name
        CadType::NAMES[type]
      end

      def x
        @vision_detected.xc[@index]
      end

      def y
        @vision_detected.yc[@index]
      end

      def orientation_angle
        @vision_detected.orientation_angle[@index]
      end

      def camera_source
        @vision_detected.camera_source[@index]
      end
    end

    def type_name
      type.map { |t| CadType::NAMES[t] }
    end

    def detections
      @detections ||= (0...detected_count).map { |i| Detection.new(self, i) }
    end

    def self.tag
      NavTag::VISION_DETECT
    end

    NavOption.register(self)
  end

end
