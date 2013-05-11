require 'argus'

drone = Argus::Drone.new
drone.start

puts "Hovering ..."
10.times do
  drone.hover
end

puts "Landing ..."
10.times do
  drone.land
end

sleep 5
drone.stop
