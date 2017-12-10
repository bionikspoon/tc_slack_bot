# frozen_string_literal: true

require 'rails_helper'

describe Event::Handle do
  before { stub_const('SLACK_TOKEN', 'secret') }

  subject { described_class.call(params) }

  let(:status) { subject[:status] }

  describe 'challenge' do
    context 'with valid params' do
      let(:params) do
        {
          token: 'secret',
          challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
          type: 'url_verification'
        }
      end

      it { is_expected.to be_success }
    end

    context 'with invalid params' do
      let(:params) do
        { hello: 'world', token: 'secret' }
      end

      it { is_expected.to be_failure }
      it { expect(status).to eq :unprocessable_entity }
    end

    context 'with unauthorized params' do
      let(:params) do
        {
          token: 'fake_token',
          challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
          type: 'url_verification'
        }
      end

      it { is_expected.to be_failure }
      it { expect(status).to eq :unauthorized }
    end
  end

  describe 'link_shared' do
    let(:json) do
      <<~HEREDOC
        {
          "token": "secret",
          "team_id": "TXXXXXXXX",
          "api_app_id": "AXXXXXXXXX",
          "event": {
              "type": "link_shared",
              "channel": "Cxxxxxx",
              "user": "Uxxxxxxx",
              "message_ts": "123456789.9875",
              "links": [
                  {
                      "domain": "example.com",
                      "url": "https://example.com/12345"
                  },
                  {
                      "domain": "example.com",
                      "url": "https://example.com/67890"
                  },
                  {
                      "domain": "another-example.com",
                      "url": "https://yet.another-example.com/v/abcde"
                  }
              ]
          },
          "type": "event_callback",
          "authed_users": [
              "UXXXXXXX1",
              "UXXXXXXX2"
          ],
          "event_id": "Ev08MFMKH6",
          "event_time": 123456789
        }
      HEREDOC
    end
    let(:params) { JSON.parse(json, symbolize_names: true) }

    it { is_expected.to be_success }
  end
end
