# frozen_string_literal: true

require 'rails_helper'

describe API::Github, type: :services do
  before do
    stub_const('GITHUB_TOKEN', 'secret')
    stub_const('GITHUB_USER', 'user')
  end

  let(:headers) do
    {
      'Accept' => 'application/vnd.github.v3+json',
      'Authorization' => 'token secret',
      'Content-Type' => 'application/json; charset=utf-8',
      'User-Agent' => 'user'
    }
  end

  it 'sends post with params' do
    response = double(code: 200, to_json: '{}')
    expect(API::Github).to receive(:get).with(
      '/repos/thinkCERCA/thinkCERCA/pulls/1',
      headers: headers
    ).and_return(response)
    API::Github.pr('thinkCERCA', 'thinkCERCA', 1)
  end
end
