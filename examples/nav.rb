require 'argus'

nav = Argus::NavStreamer.new
nav.start

while navdata = nav.receive_data

  p "sequence number: #{navdata.sequence_number}"
  p "vision flag: #{navdata.vision_flag}"
  p "Drone.flying? #{navdata.flying?}"
  puts "DBG: navdata.communication_lost?=#{navdata.communication_lost?.inspect}"
  puts "DBG: navdata.com_watchdog_problem?=#{navdata.com_watchdog_problem?.inspect}"
  p "options...."
  navdata.options.each do |opt|
    p opt.class.name
  end
end
