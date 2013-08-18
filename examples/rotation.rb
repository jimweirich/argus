require 'argus'

drone = Argus::Drone.new
drone.start

drone.take_off
sleep 5
drone.turn_right(1.0)
sleep 2
drone.turn_left(1.0)
sleep 2
drone.hover
sleep 1
drone.land
sleep 2
drone.stop
