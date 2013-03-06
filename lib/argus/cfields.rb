require 'argus/float_encoding'

module Argus

  module CFields
    include FloatEncoding

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def initialize(*args)
      super
      @data = unpack_data(args.first)
    end

    def unpack_data(data)
      @data = data.unpack(self.class.format_string)
    end

    module ClassMethods
      def data_index
        @data_index ||= 0
      end

      def format_string
        @format_string ||= "x4"
      end

      def allot(n=1)
        result = data_index
        @data_index += n
        result
      end

      def uint32_t(name)
        index = allot
        format_string << "V"
        define_method(name) { @data[index] }
      end

      def uint16_t(name)
        index = allot
        format_string << "v"
        define_method(name) { @data[index] }
      end

      def float32_t(name)
        index = allot
        format_string << "V"
        define_method(name) { decode_float(@data[index]) }
      end

      def int32_t(name)
        index = allot
        format_string << "l<"
        define_method(name) { @data[index] }
      end

      def matrix33_t(name)
        index = allot(9)
        format_string << "V9"
        define_method(name) { nil }
      end

      def vector31_t(name)
        index = allot(3)
        format_string << "V3"
        define_method(name) { nil }
      end
    end
  end

end
