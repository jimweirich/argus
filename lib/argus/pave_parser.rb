module Argus
  class PaVEParser
    def initialize(tcp_video_streamer)
      @tcp_video_streamer = tcp_video_streamer
    end

    def get_frame
      frame = {
        :signature=>(@tcp_video_streamer.read(4)).unpack("A*").first,
        :version=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :video_codec=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :header_size=>(@tcp_video_streamer.read(2)).unpack("v").first,
        :payload_size=>(@tcp_video_streamer.read(4)).unpack("V").first,
        :encoded_stream_width=>(@tcp_video_streamer.read(2)).unpack("v").first,
        :encoded_stream_height=>(@tcp_video_streamer.read(2)).unpack("v").first,
        :display_width=>(@tcp_video_streamer.read(2)).unpack("v").first,
        :display_height=>(@tcp_video_streamer.read(2)).unpack("v").first,
        :frame_number=>(@tcp_video_streamer.read(4)).unpack("V").first,
        :timestamp=>(@tcp_video_streamer.read(4)).unpack("V").first,
        :total_chunks=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :chunk_index=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :frame_type=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :control=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :stream_byte_position_lw=>(@tcp_video_streamer.read(4)).unpack("V").first,
        :stream_byte_position_uw=>(@tcp_video_streamer.read(4)).unpack("V").first,
        :stream_id=>(@tcp_video_streamer.read(2)).unpack("v").first,
        :total_slices=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :slice_index=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :header1_size=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :header2_size=>(@tcp_video_streamer.read(1)).unpack("C").first,
        :reserved[2]=>(@tcp_video_streamer.read(2)).unpack("H*").first,
        :advertised_size=>(@tcp_video_streamer.read(4)).unpack("V").first,
        :reserved[12]=>(@tcp_video_streamer.read(12)).unpack("H*").first
      }
      @tcp_video_streamer.read(4)
      return @tcp_video_streamer.read(frame[:payload_size])
    end
  end
end
