require 'argus'
require 'socket'

socket = TCPSocket.open('192.168.1.1', 5555)
streamer = Argus::TcpVideoStreamer.new(socket)
parser = Argus::PaVEParser.new(streamer)

h246_out = File.new("/tmp/#{Time.now.to_i}.h246", "w+b")

streamer.start_stream

while true do
  h246_out.write parser.get_frame
end
