# frozen_string_literal: true

require 'rails_helper'

describe API::Slack, type: :services do
  before { stub_const('SLACK_OAUTH_TOKEN', 'secret') }

  let(:headers) do
    {
      'Authorization' => 'Bearer secret',
      'Content-Type' => 'application/json; charset=utf-8'
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

  it 'sends post with params' do
    expect(API::Slack).to receive(:post).with(
      '/chat.unfurl',
      headers: headers,
      body: body.to_json
    )
    API::Slack.unfurl(body)
  end
end
