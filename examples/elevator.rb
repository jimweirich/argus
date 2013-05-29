require 'argus'

class FauxDrone
  def method_missing(*args)
    self
  end
end

class MovingAverage
  def initialize(size=20)
    @size = size
    @points = []
  end

  def <<(new_value)
    @points << new_value
    @points.shift if @points.size > @size
  end

  def value
    if @points.empty?
      0
    else
      sum = @points.inject(0.0) { |s, v| s+v }
      sum / @points.size
    end
  end
end

require 'base64'

class NavLogger
  def initialize(file_name)
    @file_name = file_name
    @file = open(file_name, "w")
  end

  def call(data)
    @file.write(Base64.encode64(data.raw))
  end

  def close
    @file.close
  end
end

class WatchDogMonitor
  def initialize(drone)
    @drone = drone
  end
  def call(data)
    if data.com_watchdog_problem?
      @drone.reset_watchdog
    end
  end
end

class NavInfoDisplay
  def initialize(drone)
    @drone = drone
    @last_update = Time.now - 30
    @ave = 0
    @max = 0
  end

  def call(data)
    if @drone && @drone.nav && @drone.nav.streamer
      state = @drone.nav.streamer.state.to_s
    else
      state = :unknown
    end
    update_timing
    print "\033[0;0f"
    print "\033[2J"
    printf "Ave: %0.4f, Max: %0.4f (%s)\n", @ave, @max, state
    puts "Seq: #{data.sequence_number}"
    puts "  Vision flag: #{data.vision_flag}"
    puts "  Flying? #{data.flying?}"
    puts "  Com Lost? #{data.communication_lost?.inspect}"
    puts "  Com     WD Problem? #{data.com_watchdog_problem?.inspect}"
    puts "  Control WD Delayed? #{data.control_watchdog_delayed?.inspect}"
    puts "  ADC     WD Delayed? #{data.adc_watchdog_delayed?.inspect}"
    puts "  Bootstrap: #{data.bootstrap?}"

    puts "options...."
    data.options.each do |opt|
      display_option(opt)
    end
    puts
  end

  private

  def update_timing
    if Time.now - @last_update > 5
      times = @drone.commander.timestamps.dup
      diffs = times.zip(times[1..-1]).map { |a, b| b ? b-a : 0 }
      @max = diffs.max
      @ave = diffs.inject(0) { |a,n| a + n } / diffs.size
      @last_update = Time.now
    end
  end

  def display_option(opt)
    puts opt.class.name
    if opt.is_a?(Argus::NavOptionDemo)
      printf "  State: %s (%d)\n", opt.control_state_name, opt.control_state
      printf "  Battery Level %d\n", opt.battery_level
      printf("  Pitch: %-8.2f  Roll: %-8.2f  Yaw: %-8.2f\n",
        opt.pitch, opt.roll, opt.yaw)
      printf("  Altitude: %08.2f\n", opt.altitude)
      printf("  Velocity: %0.2f, %0.2f, %0.2f\n",
        opt.vx, opt.vy, opt.vz)
    elsif opt.is_a?(Argus::NavOptionVisionDetect)
      puts "  Number detected: #{opt.detected_count}"

      if opt.detected_count > 0
        d = opt.detections.first
        printf("TYPE:%s/%s (%03d,%03d) %03dw %03dh @ %03dd Angle:%0.2f on %d\n",
          d.type, d.type_name, d.x, d.y, d.width, d.height, d.distance,
          d.orientation_angle, d.camera_source)
      end
    end
  end
end

class Tracker
  def initialize(drone)
    @drone = drone
    @led = nil
    @led_update = Time.now
    @done = false
    @dist_ave = MovingAverage.new(50)
    @x_ave = MovingAverage.new(20)
    @y_ave = MovingAverage.new(20)
  end

  def done
    @done = true
  end

  def call(data)
    return if @done
    data.options.each do |opt|
      if opt.is_a?(Argus::NavOptionVisionDetect)
        if opt.detected_count == 0
          drone.hover
          puts "HOVERING (LOST)"
          target_lost

        elsif opt.detected_count > 0
          d = opt.detections.first
          @x_ave << d.x
          @y_ave << d.y
          @dist_ave << d.distance
          turn_movement = 0.0
          vertical_movement = 0.0

          if @x_ave.value < 400
            turn_movement = -0.5
          elsif @x_ave.value > 600
            turn_movement = 0.5
          elsif @y_ave.value < 400
            vertical_movement = 0.5
          elsif @y_ave.value > 600
            vertical_movement = -0.5
          end

          if turn_movement != 0.0 || vertical_movement != 0.0
            puts "RIGHT: #{turn_movement} UP #{vertical_movement}"
            drone.turn_right(turn_movement)
            drone.up(vertical_movement)
            drone.forward(0.0)
          else
            puts "HOVERING (TRACKING)"
            drone.hover
          end

          target_aquired
        end
      end
    end
  end

  private

  attr_reader :drone

  def target_aquired
    if @led != :aquired || led_time_out
      @led = :aquired
      @led_update = Time.now
      drone.controller.led(:green, 2.0, 3)
    end
  end

  def target_lost
    if @led != :lost || led_time_out
      @led = :lost
      @led_update = Time.now
      drone.controller.led(:red, 2.0, 3)
    end
  end

  def led_time_out
    (Time.now - @led_update) > 2.0
  end
end

drone = Argus::Drone.new
drone.start

drone.reset_watchdog
drone.controller.enable_detection(2)

flying = ARGV.shift
if flying
  puts "Ready to fly?"
  gets
  cdrone = drone
else
  cdrone = FauxDrone.new
end

wd_monitor = WatchDogMonitor.new(drone)
drone.nav_callback(wd_monitor)

info = NavInfoDisplay.new(drone)
drone.nav_callback(info)

tracker = Tracker.new(cdrone)
drone.nav_callback(tracker)

logger = NavLogger.new("navdata.raw64")
drone.nav_callback(logger)

cdrone.take_off

while line = gets
  line.strip!
  break if line == ""
  drone.controller.led(line, 2.0, 4)
end

tracker.done
cdrone.hover
10.times do cdrone.land end
drone.stop

logger.close
