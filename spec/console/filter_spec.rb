# frozen_string_literal: true

require_relative '../support/custom_matchers'

RSpec.describe 'bin/filter' do
  subject { `bin/filter #{filename}` }

  context 'when valid sample file is passed' do
    let(:filename) { 'samples/customers' }

    it { is_expected.to have_output('spec/fixtures/output/customers') }
  end
end
