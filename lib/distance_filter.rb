# frozen_string_literal: true

require_relative './distance_calculator'

class DistanceFilter
  def initialize(longitude, latitude, distance)
    @from = DistanceCalculator.new(longitude, latitude)
    @distance = distance
  end

  def affirm(record)
    @from.to(record[:longitude], record[:latitude]).distance < @distance
  end
end
