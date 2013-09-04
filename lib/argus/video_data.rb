module Argus
  class VideoData
    attr_reader :socket, :envelope, :frame

    def initialize(socket)
      @socket = socket
      @envelope = VideoDataEnvelope.new(@socket)
      @frame = parse_frame
    end

    def parse_frame
      socket.read(envelope.payload_size) if envelope
    end
  end
end
