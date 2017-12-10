# frozen_string_literal: true

class UnfurlLinkJob < ApplicationJob
  queue_as :default

  def perform(token:, channel:, ts:, domain:, url:)
    unfurls = {
      "#{url}": {
        text: 'Every day is the test.'
      }
    }
    body = {
      token: token,
      channel: channel,
      ts: ts,
      unfurls: ERB::Util.url_encode(unfurls.to_json)
    }

    API::Slack.post('/chat.unfurl', body: body)
  end
end
