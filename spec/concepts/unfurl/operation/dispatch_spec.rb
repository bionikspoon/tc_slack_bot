# frozen_string_literal: true

require 'rails_helper'

describe Unfurl::Dispatch do
  describe 'dispatch!' do
    subject do
      op = described_class.new
      op.dispatch!(op, params: params)
    end

    context 'with pivotal domain' do
      let(:params) { { domain: 'pivotaltracker.com' } }

      it { is_expected.to eq Unfurl::Pivotal }
    end

    context 'with github domain' do
      let(:params) { { domain: 'github.com' } }

      it { is_expected.to eq Unfurl::Github }
    end

    context 'with unknown domain' do
      let(:params) { { domain: 'example.com' } }

      it { is_expected.to eq Unfurl::Unknown }
    end
  end
end
