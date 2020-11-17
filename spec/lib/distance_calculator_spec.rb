# frozen_string_literal: true

require_relative '../../lib/distance_calculator'

RSpec.describe DistanceCalculator, '.degrees_to_radians' do
  subject { calculator.degrees_to_radians(degtrees) }

  let(:calculator) { described_class }

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

RSpec.describe DistanceCalculator, '#absolute_longitude_difference' do
  subject { calculator.absolute_longitude_difference }

  let(:calculator) { described_class.new(0, 0) }

  [
    { source: 0, destination: 0, expected: 0 },
    { source: -10, destination: 10, expected: 20 },
    { source: 10, destination: -10, expected: 20 },
    { source: -10, destination: -20, expected: 10 },
    { source: 10, destination: 20, expected: 10 }
  ].each do |fixture|
    context "when source #{fixture[:source]} and destination #{fixture[:destination]}" do
      let(:expected) { fixture[:expected] }

      before do
        allow(calculator).to receive(:source_longitude).and_return(fixture[:source])
        allow(calculator).to receive(:destination_longitude).and_return(fixture[:destination])
      end

      it { is_expected.to eq(expected) }
    end
  end
end

RSpec.describe DistanceCalculator, '#central_angle' do
  subject { calculator.central_angle }

  let(:calculator) { described_class.new(0, 0) }

  [
    { alon: 0, alat: 0, blon: 0, blat: 0, expected: 0 },
    { alon: 1, alat: 1, blon: 1, blat: 1, expected: 0 },
    { alon: 1, alat: 0, blon: 0, blat: 0, expected: 0.9999999999999999 },
    { alon: 0, alat: 0, blon: 1, blat: 0, expected: 0.9999999999999999 },
    { alon: 0, alat: 1, blon: 0, blat: 0, expected: 0.9999999999999999 },
    { alon: 0, alat: 0, blon: 0, blat: 1, expected: 0.9999999999999999 },
    { alon: 0, alat: 0, blon: 1, blat: 1, expected: 1.2745557823062943 },
    { alon: 1, alat: 1, blon: 0, blat: 0, expected: 1.2745557823062943 },
    { alon: -1, alat: -1, blon: 0, blat: 0, expected: 1.2745557823062943 }
  ].each do |fixture|
    context "when source(#{fixture[:alon]}, #{fixture[:alat]}) and destination(#{fixture[:blon]}, #{fixture[:blat]})" do
      let(:expected) { fixture[:expected] }

      before do
        allow(calculator).to receive(:source_longitude).and_return(fixture[:alon])
        allow(calculator).to receive(:source_latitude).and_return(fixture[:alat])
        allow(calculator).to receive(:destination_longitude).and_return(fixture[:blon])
        allow(calculator).to receive(:destination_latitude).and_return(fixture[:blat])
      end

      it { is_expected.to eq(expected) }
    end
  end
end

RSpec.describe DistanceCalculator, '#set_destination' do
  subject(:calculator) { described_class.new(0, 0) }

  it { expect(calculator.destination_longitude).to be_nil }
  it { expect(calculator.destination_latitude).to be_nil }

  context 'when destination location is set' do
    before do
      calculator.set_destination(3.3333333, -4.4444444)
    end

    it { expect(calculator.destination_longitude).to eq(3.3333333) }
    it { expect(calculator.destination_latitude).to eq(-4.4444444) }
  end
end
