require 'spec_helper'

module Argus

  describe FlightAnimation do
    describe ".lookup_name" do
      Then { FlightAnimation.lookup_name(3) == :theta_30_deg }
    end

    describe ".lookup_value" do
      Then { FlightAnimation.lookup_value(:flip_ahead) == 16 }
      Then { FlightAnimation.lookup_value("flip_ahead") == 16 }
      Then { FlightAnimation.lookup_value(16) == 16 }
      Then { FlightAnimation.lookup_value("16") == 16 }

      Then { FlightAnimation.lookup_value(:unknown) == nil }
      Then { FlightAnimation.lookup_value("UNKNOWN") == nil }
    end
  end

end
