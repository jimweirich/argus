module Argus
  class Controller

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

    private

    def update_ref
      n = 0
      n |= 0x200 if @flying
      n |= 0x100 if @emergency
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

    def encode_float(float)
      [float].pack('g').unpack("l>").first
    end

  end
end
