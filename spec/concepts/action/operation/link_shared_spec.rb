# frozen_string_literal: true

require 'rails_helper'

describe Action::LinkShared do
  describe '#call' do
    let(:params) do
      ActionController::Parameters.new(
        token: 'secret',
        event: {
          channel: 'Cxxxxxx',
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
        }
      )
    end

    context 'with subject' do
      subject { described_class.call(params) }

      before { allow(UnfurlLinkJob).to receive(:perform_later) }

      it { is_expected.to be_success }
      its([:json]) { is_expected.to eq(status: :ok) }
      its([:status]) { is_expected.to eq :ok }
    end

    context 'with UnfurlLinkJob mock' do
      after { described_class.call(params) }

      let(:job_params) do
        {
          channel: 'Cxxxxxx',
          ts: '123456789.9875',
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
        }
      end

      it 'queues all urls' do
        expect(UnfurlLinkJob).to receive(:perform_later).with(job_params)
      end
    end
  end
end
