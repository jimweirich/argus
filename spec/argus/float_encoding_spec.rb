require 'spec_helper'

module Argus

  describe FloatEncoding do
    Given(:f) { 5.0 }
    Given(:encoded_f) { 1084227584 }
    Then { FloatEncoding.encode_float(f) == encoded_f }
    Then { FloatEncoding.decode_float(encoded_f) == f }
  end

end
