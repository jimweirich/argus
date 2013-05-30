require 'argus'

drone = Argus::Drone.new(remote_host: '192.168.1.200')
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
