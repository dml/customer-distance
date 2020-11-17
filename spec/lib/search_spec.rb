# frozen_string_literal: true

require_relative '../../lib/search'

RSpec.describe Search do
  subject { search }

  let(:search) { described_class.new }

  it { is_expected.to be_happy }
end
