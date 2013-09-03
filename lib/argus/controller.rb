require 'argus/float_encoding'
require 'argus/ardrone_control_modes'

module Argus
  class Controller
    include FloatEncoding

    def initialize(at_commander)
      @at_commander = at_commander

      @emergency = false
      land
      hover
    end

    def take_off
      @flying = true
      @emergency = false
      update_ref
    end

    def land
      @flying = false
      update_ref
    end

    def emergency
      @flying = false
      @emergency = true
      update_ref
    end

    def hover
      @moving = false
      @roll = 0.0
      @pitch = 0.0
      @gaz = 0.0
      @yaw = 0.0
      update_pcmd
    end

    def forward(amount)
      @moving = true
      @pitch = -amount
      update_pcmd
    end

    def backward(amount)
      @moving = true
      @pitch = amount
      update_pcmd
    end

    def left(amount)
      @moving = true
      @roll = -amount
      update_pcmd
    end

    def right(amount)
      @moving = true
      @roll = amount
      update_pcmd
    end

    def up(amount)
      @moving = true
      @gaz = amount
      update_pcmd
    end

    def down(amount)
      @moving = true
      @gaz = -amount
      update_pcmd
    end

    def turn_left(amount)
      @moving = true
      @yaw = -amount
      update_pcmd
    end

    def turn_right(amount)
      @moving = true
      @yaw = amount
      update_pcmd
    end

    def led(selection, hertz, duration)
      selection = LedAnimation.lookup_value(selection)
      value = [
        selection,
        FloatEncoding.encode_float(hertz),
        duration
      ].join(',')
      @at_commander.config("leds:leds_anim",value)
      self
    end

    def enable_detection(colors, type=10, select=32)
      config("detect:enemy_colors",colors.to_s)
      config("detect:detect_type", type.to_s)
      config("detect:detections_select_h", select.to_s)
      self
    end

    def config(key, value)
      @at_commander.config(key, value)
    end

    def demo_mode
      @at_commander.config("general:navdata_demo", "TRUE")
    end

    def front_camera
      @at_commander.config("video:video_channel", "2")
    end

    def bottom_camera
      @at_commander.config("video:video_channel", "1")
    end

    def reset_watchdog
      @at_commander.comwdg
    end

    def ack_control_mode
      @at_commander.ctrl(ArdroneControlModes::ACK_CONTROL_MODE)
      self
    end

    private

    REF_BASE = [18, 20, 22, 24, 28].
      inject(0) { |flag, bitnum| flag | (1 << bitnum) }
    REF_FLY_BIT = (1 << 9)
    REF_EMERGENCY_BIT = (1 << 8)

    def update_ref
      n = REF_BASE
      n |= REF_FLY_BIT if @flying
      n |= REF_EMERGENCY_BIT if @emergency
      @at_commander.ref(n.to_s)
      self
    end

    def update_pcmd
      flags = 0
      if @moving
        flags = 1
        iroll = encode_float(@roll)
        ipitch = encode_float(@pitch)
        igaz = encode_float(@gaz)
        iyaw = encode_float(@yaw)
        data = "#{flags},#{iroll},#{ipitch},#{igaz},#{iyaw}"
      else
        data = "0,0,0,0,0"
      end
      @at_commander.pcmd(data)
      self
    end

  end
end
