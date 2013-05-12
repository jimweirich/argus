module Argus
  class VideoData
    attr_reader :tcp_video_streamer, :envelope, :frame

    def initialize(tcp_video_streamer)
      @tcp_video_streamer = tcp_video_streamer
      @envelope = parse_envelope
      tcp_video_streamer.receive_data(4) # TODO: look at why just throwing this data away
      @frame = parse_frame
    end

    def parse_envelope
      {
        :signature => get_data(4, "A*"),
        :version => get_data(1, "C"),
        :video_codec => get_data(1, "C"),
        :header_size => get_data(2, "v"),
        :payload_size => get_data(4, "V"),
        :encoded_stream_width => get_data(2, "v"),
        :encoded_stream_height => get_data(2, "v"),
        :display_width => get_data(2, "v"),
        :display_height => get_data(2, "v"),
        :frame_number => get_data(4, "V"),
        :timestamp => get_data(4, "V"),
        :total_chunks => get_data(1, "C"),
        :chunk_index => get_data(1, "C"),
        :frame_type => get_data(1, "C"),
        :control => get_data(1, "C"),
        :stream_byte_position_lw => get_data(4, "V"),
        :stream_byte_position_uw => get_data(4, "V"),
        :stream_id => get_data(2, "v"),
        :total_slices => get_data(1, "C"),
        :slice_index => get_data(1, "C"),
        :header1_size => get_data(1, "C"),
        :header2_size => get_data(1, "C"),
        :reserved_2 => get_data(2, "H*"),
        :advertised_size => get_data(4, "V"),
        :reserved_12 => get_data(12, "H*")
      }
    end

    def parse_frame
      tcp_video_streamer.receive_data(envelope[:payload_size]) if envelope[:payload_size]
    end

    def get_data(size, format)
      (tcp_video_streamer.read(size)).unpack(format).first
    end
  end
end
