require 'argus'

class FauxDrone
  def method_missing(*args)
    self
  end
end

class NavInfoDisplay
  def call(data)
    puts "Seq: #{data.sequence_number}"
    puts "  Vision flag: #{data.vision_flag}"
    puts "  Flying? #{data.flying?}"
    puts "  Com Lost? #{data.communication_lost?.inspect}"
    puts "  Watchdog Problem? #{data.com_watchdog_problem?.inspect}"
    puts "  Bootstrap: #{data.bootstrap?}"

    puts "options...."
    data.options.each do |opt|
      display_option(opt)
    end
    puts
  end

  private

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
          puts "HOVERING"
          target_lost
        elsif opt.detected_count > 0
          d = opt.detections.first
          moving = false
          if d.x < 400
            drone.turn_left(0.2)
            moving = true
            puts "TURNING LEFT"
          elsif d.x > 600
            drone.turn_right(0.2)
            moving = true
            puts "TURNING RIGHT"
          else
            drone.turn_right(0.0)
          end

          if d.y < 400
            drone.up(0.2)
            moving = true
            puts "UP"
          elsif d.y > 600
            drone.down(0.2)
            moving = true
            puts "DOWN"
          else
            drone.up(0.0)
          end

          if moving
            drone.forward(0.0)
          else
            if d.distance > 180
              drone.forward(0.1)
              moving = true
              puts "FORWARD"
            elsif d.distance < 150
              drone.backward(0.1)
              moving = true
              puts "BACKWARD"
            else
              drone.forward(0.0)
            end
          end

          if ! moving
            puts "HOVERING"
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

drone.controller.enable_detection(2)

flying = ARGV.shift
if flying
  puts "Ready to fly?"
  gets
  cdrone = drone
else
  cdrone = FauxDrone.new
end

drone.nav_callback(NavInfoDisplay.new)

tracker = Tracker.new(cdrone)
drone.nav_callback(tracker)

cdrone.take_off

while line = gets
  line.strip!
  break if line == ""
  drone.controller.led(line, 2.0, 4)
end

tracker.done
cdrone.hover.land
drone.stop
