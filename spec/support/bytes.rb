module Bytes
  module_function

  def int16(n)
    [n].pack("v").unpack("C*")
  end

  def int32(n)
    [n].pack("V").unpack("C*")
  end

  def make_nav_data(*options)
    result = [Bytes.int32(0x55667788) + options].flatten
    add_checksum(result)
    result.pack("C*")
  end

  def make_header(state_bits, seq_number, vision_flag)
    Bytes.int32(state_bits) + Bytes.int32(seq_number) + Bytes.int32(vision_flag)
  end

  def make_demo_data
    Bytes.int16(0) + Bytes.int16(148) + [0] * 144
  end

  def add_checksum(bytes)
    [0xff, 0xff, 0x08, 0x00, 0x61, 0x04, 0x00, 0x00].each do |b| bytes << b end
    bytes
  end
end
