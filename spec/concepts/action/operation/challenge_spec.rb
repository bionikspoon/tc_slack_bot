# frozen_string_literal: true

require 'rails_helper'

describe Action::Challenge do
  subject { described_class.call(params) }

  let(:params) { { challenge: 'abcd' } }

  it { is_expected.to be_success }
  its([:json]) { is_expected.to eq(challenge: 'abcd') }
  its([:status]) { is_expected.to eq :ok }
end
