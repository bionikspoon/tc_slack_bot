# frozen_string_literal: true

class API::Slack
  include HTTParty
  base_uri 'https://slack.com/api'
  logger Rails.logger
  format :json
  raise_on [*400..431, *500..511]
  headers 'Authorization' => "Bearer #{SLACK_OAUTH_TOKEN}"
  headers 'Content-Type' => 'application/json; charset=utf-8'

  class << self
    def unfurl(body)
      post('/chat.unfurl', body: body.to_json)
    end
  end
end
