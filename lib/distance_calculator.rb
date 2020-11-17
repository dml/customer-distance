# frozen_string_literal: true

class DistanceCalculator
  def self.degrees_to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end
end
