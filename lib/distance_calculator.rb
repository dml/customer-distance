# frozen_string_literal: true

class DistanceCalculator
  attr_reader :source_longitude,
              :source_latitude,
              :destination_longitude,
              :destination_latitude

  def initialize(longitude, latitude)
    @source_longitude = longitude
    @source_latitude = latitude
  end

  def absolute_longitude_difference
    (destination_longitude - source_longitude).abs
  end

  def self.degrees_to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end
end
