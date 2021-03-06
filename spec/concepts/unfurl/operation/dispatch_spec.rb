# frozen_string_literal: true

require 'rails_helper'

describe Unfurl::Dispatch do
  describe '#call' do
    let(:params) do
      {
        channel: 'C123456',
        ts: '123456789.9875',
        links: [
          {
            domain: 'github.com',
            url: 'https://github.com/ThinkCERCA/thinkCERCA/pull/1'
          },
          {
            domain: 'github.com',
            url: 'https://github.com/ThinkCERCA/thinkCERCA/pull/2'
          }
        ]
      }
    end
    let(:body) do
      {
        channel: 'C123456',
        ts: '123456789.9875',
        unfurls: {
          'https://github.com/ThinkCERCA/thinkCERCA/pull/1': {
            text: 'Every day is the test.'
          },
          'https://github.com/ThinkCERCA/thinkCERCA/pull/2': {
            text: 'Every day is the test.'
          }
        }
      }
    end

    let(:link_unfurl) { { unfurl: { text: 'Every day is the test.' } } }

    before { allow(Unfurl::Github).to receive(:call).and_return(link_unfurl) }
    after { described_class.call(params) }
    it 'sends a request with params' do
      expect(API::Slack).to receive(:unfurl).with(body)
    end
  end
end
