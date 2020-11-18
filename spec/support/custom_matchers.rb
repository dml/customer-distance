# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :equal_with_tolerance do |expected, tolerance|
  match do |actual|
    return false  if tolerance.nil?

    (actual - expected).abs < tolerance
  end

  description do
    "be equal to #{expected} with a tolerance #{tolerance.inspect}"
  end
end
