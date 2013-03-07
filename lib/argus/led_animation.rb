module Argus

  module LedAnimation
    NAMES = [
      :blink_green_red,
      :blink_green,
      :blink_red,
      :blink_orange,
      :snake_green_red,
      :fire,
      :standard,
      :red,
      :green,
      :red_snake,
      :blank,
      :right_missile,
      :left_missile,
      :double_missile,
      :front_left_green_others_red,
      :front_right_green_others_red,
      :rear_right_green_others_red,
      :rear_left_green_others_red,
      :left_green_right_red,
      :left_red_right_green,
      :blink_standard,
    ]

    VALUES = {}
    NAMES.each.with_index { |name, index| VALUES[name] = index }

    def self.lookup_name(numeric_value)
      NAMES[numeric_value]
    end

    def self.lookup_value(symbolic_name)
      case symbolic_name
      when Symbol
        VALUES[symbolic_name]
      when Integer
        symbolic_name
      when /^\d+/
        symbolic_name.to_i
      when String
        VALUES[symbolic_name.intern]
      end
    end
  end
end
