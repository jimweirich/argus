require 'argus'

class FauxDrone
  def method_missing(*args)
    self
  end
end

class NavInfoDisplay
  def call(data)
    puts "Seq: #{navdata.sequence_number}"
    puts "  Vision flag: #{navdata.vision_flag}"
    puts "  Flying? #{navdata.flying?}"
    puts "  Com Lost? #{navdata.communication_lost?.inspect}"
    puts "  Watchdog Problem? #{navdata.com_watchdog_problem?.inspect}"
    puts "  Bootstrap: #{navdata.bootstrap?}"

    puts "options...."
    navdata.options.each do |opt|
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
  end

  def call(data)
    navdata.options.each do |opt|
      if opt.is_a?(Argus::NavOptionVisionDetect)
        if opt.detected_count == 0
          drone.hover
          puts "HOVERING"
        elsif opt.detected_count > 0
          d = opt.detections.first
          if d.x < 400
            drone.turn_left(0.2)
            puts "TURNING LEFT"
          elsif d.x > 600
            drone.turn_right(0.2)
            puts "TURNING RIGHT"
          else
            puts "HOVERING"
            drone.hover
          end
        end
      end
    end
  end

  private

  attr_reader :drone
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

puts "DBG: CALLBACK"
drone.nav_callback(NavInfoDisplay.new)
drone.nav_callback(Tracker.new(cdrone))


cdrone.take_off
puts "DBG: GETS"
while line = gets
  line.strip!
  break if line == ""
  drone.controller.led(line, 2.0, 4)
end

cdrone.hover.land

drone.stop
