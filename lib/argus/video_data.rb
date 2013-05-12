module Argus
  class VideoData
    attr_reader :streamer, :envelope, :frame

    def initialize(streamer)
      @streamer = streamer
      @envelope = VideoDataEnvelope.new(@streamer)
      @streamer.receive_data(4) # TODO: look at why just throwing this data away
      @frame = parse_frame
    end

    def parse_frame
      streamer.receive_data(envelope.payload_size) if envelope
    end
  end
end
