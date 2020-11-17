# frozen_string_literal: true

require_relative '../../lib/distance_calculator'

RSpec.describe DistanceCalculator do
  subject { calculator }

  let(:calculator) { described_class }

  describe '.degrees_to_radians' do
    subject { calculator.degrees_to_radians(degtrees) }

    [
      { degtrees: 0, radians: 0 },
      { degtrees: 90, radians: Math::PI / 2 },
      { degtrees: 180, radians: Math::PI },
      { degtrees: -90, radians: -1 * Math::PI / 2 },
      { degtrees: -180, radians: -1 * Math::PI }
    ].each do |fixture|
      context "when #{fixture[:degtrees]} degrees passed" do
        let(:degtrees) { fixture[:degtrees] }
        let(:radians) { fixture[:radians] }

        it { is_expected.to eq(radians) }
      end
    end
  end
end
