require 'spec_helper'

module Argus
  describe VideoData do
    Given(:raw_header) { Bytes.make_header(state_bits, seq_num, vision_flag) }
    Given(:raw_video_bytes) { Bytes.make_video_data(raw_header) }
    Given(:streamer) { flexmock("Streamer", :read => unpacker) }

    When(:video_data) { VideoData.new(streamer) }

    pending "some tests"
  end
end
