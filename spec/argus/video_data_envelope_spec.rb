require 'spec_helper'

module Argus
  describe VideoDataEnvelope do
    Given(:unpacker) { flexmock("Unpacker", :unpack => values) }
    Given(:streamer) { flexmock("Streamer", :read => unpacker) }
    Given(:video_data_envelope) { VideoDataEnvelope.new(streamer) }

    describe "version" do
      When(:values) { flexmock("Values", :first => 3) }
      Then { video_data_envelope.version == 3 }
    end

    describe "frame_number" do
      When(:values) { flexmock("Values", :first => 42) }
      Then { video_data_envelope.frame_number == 42 }
    end

    describe "payload_size" do
      When(:values) { flexmock("Values", :first => 2048) }
      Then { video_data_envelope.payload_size == 2048 }
    end
  end
end
