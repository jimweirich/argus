module Argus
  module FloatEncoding
    module_function

    def encode_float(float)
      [float].pack('g').unpack("l>").first
    end

    def decode_float(encoded_float)
      [encoded_float].pack("l>").unpack("g").first
    end
  end
end
