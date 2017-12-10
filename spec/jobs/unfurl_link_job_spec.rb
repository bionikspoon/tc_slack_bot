# frozen_string_literal: true

require 'rails_helper'

describe UnfurlLinkJob, type: :job do
  let(:request) do
    class_double('API::Slack')
      .as_stubbed_const(transfer_nested_constants: true)
  end
  let(:params) do
    {
      token: 'secret',
      channel: 'C123456',
      ts: '123456789.9875',
      domain: 'example.com',
      url: 'https://example.com/12345'
    }
  end

  it 'sends a request with params' do
    expected_params = {
      body: {
        token: 'secret',
        channel: 'C123456',
        ts: '123456789.9875',
        unfurls: '%7B%22https%3A%2F%2Fexample.com%2F12345%22%3A%7B%22text%22%3A%22Every%20day%20is%20the%20test.%22%7D%7D'
      }
    }
    expect(request).to receive(:post).with('/chat.unfurl', expected_params)
    UnfurlLinkJob.perform_now(params)
  end
end
