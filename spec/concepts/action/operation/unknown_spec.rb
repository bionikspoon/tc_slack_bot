# frozen_string_literal: true

require 'rails_helper'

describe Action::Unknown do
  describe '#call' do
    subject { described_class.call }

    it { is_expected.to be_failure }
    its([:json]) { is_expected.to eq(error: :unprocessable_entity) }
    its([:status]) { is_expected.to eq :unprocessable_entity }
  end
end
