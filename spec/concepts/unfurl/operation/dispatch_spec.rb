# frozen_string_literal: true

require 'rails_helper'

describe Unfurl::Dispatch do
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

  it 'sends a request with params' do
    body = {
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
    unfurl = { text: 'Every day is the test.' }
    allow(Unfurl::Github).to receive(:call).and_return(unfurl: unfurl)

    expect(API::Slack).to receive(:unfurl).with(body)
    described_class.call(params)
  end
end
