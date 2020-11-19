# frozen_string_literal: true

require_relative '../../lib/distance_filter'

RSpec.describe DistanceFilter do
  let(:filter) do
    described_class.new(-6.257664, 53.339428, 100.0)
  end

  describe '#affirm' do
    subject { filter.affirm(record) }

    context 'when location is inside the range' do
      let(:record) { { longitude: -6.257664, latitude: 53.339428 } }

      it { is_expected.to be_truthy }
    end

    context 'when location is out of the range' do
      let(:record) { { longitude: -8.5127, latitude: 51.9067 } }

      it { is_expected.to be_falsey }
    end
  end
end
