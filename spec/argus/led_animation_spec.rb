require 'spec_helper'

module Argus

  describe LedAnimation do
    describe ".lookup_name" do
      Then { LedAnimation.lookup_name(3) == :blink_orange }
    end

    describe ".lookup_value" do
      Then { LedAnimation.lookup_value(:blink_orange) == 3 }
      Then { LedAnimation.lookup_value("blink_orange") == 3 }
      Then { LedAnimation.lookup_value(3) == 3 }
      Then { LedAnimation.lookup_value("3") == 3 }

      Then { LedAnimation.lookup_value(:unknown) == nil }
      Then { LedAnimation.lookup_value("UNKNOWN") == nil }
    end
  end

end
