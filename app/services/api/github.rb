# frozen_string_literal: true

class API::Github
  include HTTParty
  base_uri 'https://api.github.com'
  logger Rails.logger

  class << self
    def pr(owner, repo, pr)
      _get("/repos/#{owner}/#{repo}/pulls/#{pr}")
    end

    def _get(*args, **kwargs)
      response = get(*args, headers: headers, **kwargs)

      JSON.parse(response.to_json, symbolize_names: true)
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
