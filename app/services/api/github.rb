# frozen_string_literal: true

class API::Github
  include HTTParty
  base_uri 'https://api.github.com'
  logger Rails.logger

  class << self
    def pr(owner, repo, pr)
      response = get("/repos/#{owner}/#{repo}/pulls/#{pr}", headers: headers)

      case response.code
      when 200
        JSON.parse(response.to_json).deep_symbolize_keys
      else
        { error: JSON.parse(response.to_json).deep_symbolize_keys }
      end
    end

    private

    def headers
      {
        'Accept' => 'application/vnd.github.v3+json',
        'Authorization' => "token #{GITHUB_TOKEN}",
        'Content-Type' => 'application/json; charset=utf-8',
        'User-Agent' => GITHUB_USER
      }
    end
  end
end
