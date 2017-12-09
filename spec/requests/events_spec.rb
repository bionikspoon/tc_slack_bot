require 'rails_helper'

describe "Events", type: :request do
  describe "POST /events" do
    before(:each) { stub_const('SLACK_TOKEN', 'secret')}

    let(:params) do
      {
        token: 'secret',
        challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
        type: 'url_verification'
      }
    end
    before(:each) {post events_path, params: params}

    subject { response }

    it { is_expected.to have_http_status(:ok) }
  end
end
