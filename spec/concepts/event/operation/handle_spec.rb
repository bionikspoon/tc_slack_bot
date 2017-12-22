# frozen_string_literal: true

require 'rails_helper'

describe Event::Handle do
  describe '#call' do
    before { stub_const('SLACK_TOKEN', 'secret') }

    subject { described_class.call(params) }

    describe 'challenge' do
      context 'with valid params' do
        let(:params) do
          ActionController::Parameters.new(
            token: 'secret',
            challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
            type: 'url_verification'
          )
        end

        it { is_expected.to be_success }
      end

      context 'with invalid params' do
        let(:params) do
          ActionController::Parameters.new(hello: 'world', token: 'secret')
        end

        it { is_expected.to be_failure }
        its([:status]) { is_expected.to eq :unprocessable_entity }
      end

      context 'with unauthorized params' do
        let(:params) do
          ActionController::Parameters.new(
            token: 'fake_token',
            challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
            type: 'url_verification'
          )
        end

        it { is_expected.to be_failure }
        its([:status]) { is_expected.to eq :unauthorized }
      end
    end

    describe 'link_shared' do
      before { allow(UnfurlLinkJob).to receive(:perform_later) }

      let(:params) do
        ActionController::Parameters.new(
          token: 'secret',
          team_id: 'TXXXXXXXX',
          api_app_id: 'AXXXXXXXXX',
          event: {
            type: 'link_shared',
            channel: 'Cxxxxxx',
            user: 'Uxxxxxxx',
            message_ts: '123456789.9875',
            links: [
              {
                domain: 'example.com',
                url: 'https://example.com/12345'
              },
              {
                domain: 'example.com',
                url: 'https://example.com/67890'
              },
              {
                domain: 'another-example.com',
                url: 'https://yet.another-example.com/v/abcde'
              }
            ]
          },
          type: 'event_callback',
          authed_users: %w[UXXXXXXX1 UXXXXXXX2],
          event_id: 'Ev08MFMKH6',
          event_time: 123_456_789
        )
      end

      let(:job_params) do
        { channel: 'Cxxxxxx',
          ts: '123456789.9875',
          links: [
            { domain: 'example.com', url: 'https://example.com/12345' },
            { domain: 'example.com', url: 'https://example.com/67890' },
            { domain: 'another-example.com',
              url: 'https://yet.another-example.com/v/abcde' }
          ] }
      end

      it { is_expected.to be_success }

      it 'queues a job' do
        expect(UnfurlLinkJob).to receive(:perform_later).with(job_params)

        subject # rubocop:disable RSpec/NamedSubject
      end
    end
  end
end
