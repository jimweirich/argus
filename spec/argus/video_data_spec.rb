require 'spec_helper'

module Argus
  describe VideoData do
    Given(:raw_header) { Bytes.make_video_envelope }
    Given(:raw_video_bytes) { Bytes.make_video_data(raw_header) }
    Given(:video_data) { VideoData.new(socket) }

    describe "valid envelope" do
      When(:socket) { StringIO.new(raw_header) }
      Then {video_data.envelope.signature == "PaVE"}
    end

    pending "TODO: handle invalid envelope"
    pending "TODO: handle valid envelope but invalid frame"
    
  end
end
