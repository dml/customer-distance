# frozen_string_literal: true

class DistanceCalculator
  MEAN_EARTH_RADIUS = 6_371.0088 # kilometers

  attr_reader :source_longitude,
              :source_latitude,
              :destination_longitude,
              :destination_latitude

  def initialize(longitude, latitude)
    @source_longitude = DistanceCalculator.degrees_to_radians(longitude)
    @source_latitude = DistanceCalculator.degrees_to_radians(latitude)
  end

  def set_destination(longitude, latitude)
    @destination_longitude = DistanceCalculator.degrees_to_radians(longitude)
    @destination_latitude = DistanceCalculator.degrees_to_radians(latitude)
  end

  def absolute_longitude_difference
    (destination_longitude - source_longitude).abs
  end

  def central_angle
    Math.acos(
      Math.sin(source_latitude) * Math.sin(destination_latitude) +
      Math.cos(source_latitude) * Math.cos(destination_latitude) * Math.cos(absolute_longitude_difference)
    )
  end

  def distance
    MEAN_EARTH_RADIUS * central_angle
  end

  def to(longitude, latitude)
    set_destination(longitude, latitude)

    self
  end

  def self.from(longitude, latitude)
    new(longitude, latitude)
  end

  def self.degrees_to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end
end
