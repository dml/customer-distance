# frozen_string_literal: true

require_relative '../../lib/distance_calculator'

RSpec.describe DistanceCalculator do
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

        it { is_expected.to eq(radians) }
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

      it { expect(calculator.destination_longitude).to eq(0.05817764115136789) }
      it { expect(calculator.destination_latitude).to eq(-0.07757018820182386) }
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

      it { is_expected.to eq(0) }
    end

    context 'when difference is one degree on meridian' do
      let(:source) { [0, 0] }
      let(:destination) { [0, 1] }

      it { is_expected.to eq(111.19508023352181) }
    end

    context 'when source and destination points are different' do
      let(:source) { [-6.257664, 53.339428] }
      let(:destination) { [-8.5127, 51.9067] }

      it { is_expected.to eq(220.32162659875155) }
    end
  end
end
