module Argus

  module FlightAnimation
    NAMES = [
      :phi_m30_deg,
      :phi_30_deg,
      :theta_m30_deg,
      :theta_30_deg,
      :theta_20_deg_yaw_200_deg,
      :theta_20_deg_yaw_m_200_deg,
      :turnaround,
      :turnaround_go_down,
      :yaw_shake,
      :yaw_dance,
      :phi_dance,
      :theta_dance,
      :vz_dance,
      :wave,
      :phi_theta_mixed,
      :double_phi_theta_mixed,
      :flip_ahead,
      :flip_behind,
      :flip_left,
      :flip_right,
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
