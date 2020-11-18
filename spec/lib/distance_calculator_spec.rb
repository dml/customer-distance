# frozen_string_literal: true

require_relative '../support/custom_matchers'
require_relative '../../lib/distance_calculator'

RSpec.describe DistanceCalculator do
  let(:tolerance) { 1e-08 }

  describe '.degrees_to_radians' do
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

        it { is_expected.to equal_with_tolerance(radians, tolerance) }
      end
    end
  end

  describe '#absolute_longitude_difference' do
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

  describe '#central_angle' do
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
      context_definition = <<-DEFINITION
        when source(#{fixture[:alon]}, #{fixture[:alat]})
        and destination(#{fixture[:blon]}, #{fixture[:blat]})
      DEFINITION

      context context_definition do
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

  describe '#set_destination' do
    subject(:calculator) { described_class.new(0, 0) }

    it { expect(calculator.destination_longitude).to be_nil }
    it { expect(calculator.destination_latitude).to be_nil }

    context 'when destination location is set' do
      before do
        calculator.set_destination(3.3333333, -4.4444444)
      end

      it { expect(calculator.destination_longitude).to equal_with_tolerance(0.05817764115136789, tolerance) }
      it { expect(calculator.destination_latitude).to equal_with_tolerance(-0.07757018820182386, tolerance) }
    end
  end

  describe '#distance' do
    subject { calculator.distance }

    let(:calculator) { described_class.new(*source) }

    before do
      calculator.set_destination(*destination)
    end

    context 'when source and destination points are equal' do
      let(:source) { [-6.257664, 53.339428] }
      let(:destination) { [-6.257664, 53.339428] }

      it { is_expected.to equal_with_tolerance(0, tolerance) }
    end

    context 'when difference is one degree on meridian' do
      let(:source) { [0, 0] }
      let(:destination) { [0, 1] }

      it { is_expected.to equal_with_tolerance(111.19508023352181, tolerance) }
    end

    context 'when source and destination points are different' do
      let(:source) { [-6.257664, 53.339428] }
      let(:destination) { [-8.5127, 51.9067] }

      it { is_expected.to equal_with_tolerance(220.32162659875155, tolerance) }
    end
  end

  describe '.from' do
    subject(:calculator) { described_class.from(longitude, latitude) }

    let(:longitude) { '-6.257664' }
    let(:latitude) { '53.339428' }

    it { is_expected.to be_a(described_class) }
    it { expect(calculator.source_longitude).to equal_with_tolerance(-0.10921684028351844, tolerance) }
    it { expect(calculator.source_latitude).to equal_with_tolerance(0.9309486397304539, tolerance) }
  end

  describe '.to' do
    subject(:calculator) { source.to(longitude, latitude) }

    let(:source) { described_class.from('-6.257664', '53.339428') }
    let(:longitude) { '-8.5127' }
    let(:latitude) { '51.9067' }

    it { is_expected.to be_a(described_class) }
    it { expect(calculator.destination_longitude).to equal_with_tolerance(-0.1485746432345213, tolerance) }
    it { expect(calculator.destination_latitude).to equal_with_tolerance(0.9059428188449407, tolerance) }
  end
end
