require 'rails_helper'

describe EventsController, type: :controller do
  before { stub_const('SLACK_TOKEN', 'secret') }

  describe 'POST #create' do
    before { post :create, params: params }
    context 'with valid params' do
      let(:params) do
        {
          token: 'secret',
          challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
          type: 'url_verification'
        }
      end
      let(:response_body) { JSON.parse(response.body) }

      it { expect(response).to have_http_status(:ok) }

      it { expect(response.content_type).to eq('application/json') }

      it {
        expect(response_body).to eq(
          'challenge' => '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P'
        )
      }
    end
  end
end
