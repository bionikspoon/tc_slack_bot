# frozen_string_literal: true

class API::Slack
  include HTTParty
  base_uri 'https://slack.com/api'
  logger Rails.logger
end
