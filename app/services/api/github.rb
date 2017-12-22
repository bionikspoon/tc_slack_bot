# frozen_string_literal: true

class API::Github
  include HTTParty
  base_uri 'https://api.github.com'
  logger Rails.logger
  format :json
  raise_on [*400..431, *500..511]
  headers 'Accept' => 'application/vnd.github.v3+json'
  headers 'Authorization' => "token #{GITHUB_TOKEN}"
  headers 'Content-Type' => 'application/json; charset=utf-8'
  headers 'User-Agent' => GITHUB_USER

  class << self
    def pr(owner, repo, pr)
      _get("/repos/#{owner}/#{repo}/pulls/#{pr}")
    end

    def _get(*args, **kwargs)
      response = get(*args, **kwargs)

      JSON.parse(response.to_json, symbolize_names: true)
    end
  end
end
