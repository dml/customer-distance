# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :equal_with_tolerance do |expected, tolerance|
  match do |actual|
    return false if tolerance.nil?

    (actual - expected).abs < tolerance
  end

  description do
    "be equal to #{expected} with a tolerance #{tolerance.inspect}"
  end
end

RSpec::Matchers.define :have_output do |expected|
  output = IO.read(expected)

  match do |actual|
    actual == output
  end

  description do
    "have output\n\n#{output}"
  end
end
