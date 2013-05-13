require 'argus'
require 'socket'

socket = TCPSocket.open('192.168.1.1', 5555)
streamer = Argus::VideoStreamer.new(socket)

h246_out = File.new("#{Time.now.to_i}.h246", "w+b")

streamer.start

while true do
  h246_out.write streamer.receive_data.frame
end
