# frozen_string_literal: true

class API::Slack
  include HTTParty
  base_uri 'https://slack.com/api'
  logger Rails.logger

  class << self
    def unfurl(body)
      post('/chat.unfurl', headers: headers, body: body.to_json)
    end

    private

    def headers
      {
        'Authorization' => "Bearer #{SLACK_OAUTH_TOKEN}",
        'Content-Type' => 'application/json; charset=utf-8'
      }
    end
  end
end
