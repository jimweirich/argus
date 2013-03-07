require 'argus'

drone = Argus::Drone.new
drone.start

puts "STARTED"

drone.controller.enable_detection(2)

drone.nav_callback do |navdata|
  puts "Seq: #{navdata.sequence_number}"
  puts "  Vision flag: #{navdata.vision_flag}"
  puts "  Flying? #{navdata.flying?}"
  puts "  Com Lost? #{navdata.communication_lost?.inspect}"
  puts "  Watchdog Problem? #{navdata.com_watchdog_problem?.inspect}"
  puts "  Bootstrap: #{navdata.bootstrap?}"
  puts "options...."
  navdata.options.each do |opt|
    p opt.class.name
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
  puts
end

while line = gets
  line.strip!
  break if line == ""
  drone.controller.led(line, 2.0, 4)
end
