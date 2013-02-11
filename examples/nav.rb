require 'argus'

nav = Argus::NavStreamer.new
nav.start

navdata = nav.recieve

p "sequence number: #{navdata.sequence_number}"
p "vision flag: #{navdata.vision_flag}"
p "drone state..."
navdata.drone_state.each do |name, val|
  p "#{name}: #{val}"
end
p "options...."
navdata.options.each do |option|
  option.each do |name, val|
    p "#{name}: #{val}"
  end
end
