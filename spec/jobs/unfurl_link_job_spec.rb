# frozen_string_literal: true

require 'rails_helper'

describe UnfurlLinkJob, type: :job do
  before { stub_const('SLACK_OAUTH_TOKEN', 'secret') }

  let(:request) do
    class_double('API::Slack')
      .as_stubbed_const(transfer_nested_constants: true)
  end
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
    headers = {
      'Authorization' => 'Bearer secret',
      'Content-Type' => 'application/json; charset=utf-8'
    }
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

    expect(request).to receive(:post).with(
      '/chat.unfurl',
      headers: headers,
      body: body.to_json
    )
    UnfurlLinkJob.perform_now(params)
  end
end
