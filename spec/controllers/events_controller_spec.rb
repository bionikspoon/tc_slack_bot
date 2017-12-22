# frozen_string_literal: true

require 'rails_helper'

describe EventsController, type: :controller do
  before { stub_const('SLACK_TOKEN', 'secret') }

  describe 'POST #create' do
    subject { post :create, params: params }

    context 'with valid params' do
      let(:params) do
        {
          token: 'secret',
          challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
          type: 'url_verification'
        }
      end
      let(:response_json) { JSON.parse(subject.body) }

      it { is_expected.to have_http_status(:ok) }
      its(:content_type) { is_expected.to eq('application/json') }
      it { expect(response_json).to eq('challenge' => '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P') }
    end
  end
end
