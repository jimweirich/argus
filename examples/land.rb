require 'argus'

drone = Argus::Drone.new
drone.start

puts "Landing ..."
5.times do
  drone.land
  sleep 0.1
end

sleep 5
drone.stop
