# frozen_string_literal: true

require 'rails_helper'

describe 'Events', type: :request do
  before { stub_const('SLACK_TOKEN', 'secret') }
  describe 'POST /events' do
    subject { response }

    let(:params) do
      {
        token: 'secret',
        challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
        type: 'url_verification'
      }
    end

    before { post events_path, params: params }

    it { is_expected.to have_http_status(:ok) }
  end
end
