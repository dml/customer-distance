# frozen_string_literal: true

require_relative '../../lib/cli'

describe CLI do
  describe '.run' do
    subject(:run) { described_class.run }

    context 'when ARGV contains no filename' do
      before do
        allow(ARGV).to receive(:fetch).with(0).and_raise(IndexError)
      end

      it { expect { run }.to raise_error(SystemExit) }
    end

    context 'when ARGV contains filename' do
      before do
        allow(ARGV).to receive(:fetch).with(0).and_return(filename)
      end

      context 'with non-existing file' do
        let(:filename) { 'filename' }

        it { expect { run }.to raise_error(SystemExit) }
      end

      context 'with existing file' do
        let(:filename) { 'samples/customers' }

        it { expect { run }.not_to raise_error }
      end
    end
  end
end
