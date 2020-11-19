# frozen_string_literal: true

require_relative '../../lib/json_formatter'

RSpec.describe JsonFormatter do
  let(:formatter) { described_class.new }
  let(:line) { '{"name":"John Appleseed","user_id":356}' }
  let(:dataset) { { name: 'John Appleseed', user_id: 356 } }

  describe '#parse' do
    subject { formatter.parse(line) }

    it { is_expected.to eq(dataset) }
  end

  describe '#dump' do
    subject { formatter.dump(dataset) }

    it { is_expected.to eq(line) }
  end
end
