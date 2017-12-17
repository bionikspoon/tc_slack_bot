# frozen_string_literal: true

require 'rails_helper'

describe UnfurlLinkJob, type: :job do
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

  it 'sends job to Unfurl::Dispatch' do
    expect(Unfurl::Dispatch).to receive(:call).with(params)
    UnfurlLinkJob.perform_now(params)
  end
end
