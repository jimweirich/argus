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

    INDEX = {}
    NAMES.each.with_index { |name, index| INDEX[name] = index }
  end
end
