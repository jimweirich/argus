require 'argus/float_encoding'

module Argus

  module CFields
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
        @format_string ||= (defined?(initial_format) ? initial_format : "")
      end

      def allot(n=1)
        result = data_index
        @data_index += n
        result
      end

      def define_field(name, size, format, width=1, &transform)
        if size
          define_array_field(name, size, format, width, transform)
        else
          define_scaler_field(name, format, width, transform)
        end
      end

      def define_scaler_field(name, format, width, transform)
        index = allot(width)
        format_string << (width==1 ? format : "#{format}#{width}")
        define_method(name) { @data[index] }
      end

      def define_array_field(name, size, format, width, transform)
        index = allot(width*size)
        format_string << "#{format}#{width*size}"
        define_method(name) { @data[index, width*size] }
      end

      def uint32_t(name, size=nil)
        define_field(name, size, "V")
      end

      def uint16_t(name, size=nil)
        define_field(name, size, "v")
      end

      def float32_t(name, size=nil)
        define_field(name, size, "e")
      end

      def int32_t(name, size=nil)
        define_field(name, size, "l<")
      end

      def matrix33_t(name, size=nil)
        define_field(name, size, "V", 9)
      end

      def vector31_t(name, size=nil)
        define_field(name, size, "V", 3)
      end
    end
  end

end
