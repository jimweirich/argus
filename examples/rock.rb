require 'argus'

drone = Argus::Drone.new
drone.start

drone.take_off
sleep 5
2.times do
  drone.left(0.3)
  sleep 1
  drone.right(0.3)
  sleep 1
end
drone.hover
sleep 1
drone.land
sleep 5
drone.stop
