# frozen_string_literal: true

require_relative '../../lib/search'

RSpec.describe Search do
  let(:search) { described_class.new }
  let(:formatter) { double }
  let(:filter) { double }

  before do
    allow(search).to receive(:formatter).and_return(formatter)
    allow(search).to receive(:filter).and_return(filter)
  end

  describe '#process' do
    subject { search.data }

    let(:record) do
      {
        latitude: '53.4692815',
        user_id: 7,
        name: 'Frank Kehoe',
        longitude: '-9.436036'
      }
    end

    context 'when record is parsed' do
      before do
        allow(formatter).to receive(:parse).with('test_line').and_return(record)
        allow(filter).to receive(:affirm).with(record).and_return(affirm)

        search.process(['test_line'])
      end

      context 'when filter affirmed' do
        let(:affirm) { true }

        it { expect(search.data).to include({ 7 => 'Frank Kehoe' }) }
      end

      context 'when filter rejected' do
        let(:affirm) { false }

        it { expect(search.data).not_to include({ 7 => 'Frank Kehoe' }) }
      end
    end
  end

  describe '#print_sorted' do
    let(:output) { instance_spy('output') }

    let(:data) do
      {
        3345 => 'test name #1',
        2345 => 'test name #2',
        7345 => 'test name #3'
      }
    end

    before do
      allow(search).to receive(:data).and_return(data)
      allow(formatter).to receive(:dump) { |dataset| dataset }
    end

    it 'puts formatter dataset' do
      search.print_sorted(output)

      expect(output).to have_received(:puts).with({ name: 'test name #2', user_id: 2345 }).ordered
      expect(output).to have_received(:puts).with({ name: 'test name #1', user_id: 3345 }).ordered
      expect(output).to have_received(:puts).with({ name: 'test name #3', user_id: 7345 }).ordered
    end
  end
end
