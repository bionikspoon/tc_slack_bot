# frozen_string_literal: true

require 'rails_helper'

describe API::Github, type: :services do
  before do
    stub_const('GITHUB_TOKEN', 'secret')
    stub_const('GITHUB_USER', 'user')
  end
  after { described_class.pr('thinkCERCA', 'thinkCERCA', 1) }

  let(:headers) do
    {
      'Accept' => 'application/vnd.github.v3+json',
      'Authorization' => 'token secret',
      'Content-Type' => 'application/json; charset=utf-8',
      'User-Agent' => 'user'
    }
  end

  it 'sends post with params' do
    expect(described_class).to receive(:get).with(
      '/repos/thinkCERCA/thinkCERCA/pulls/1',
      headers: headers
    ).and_return(instance_double(HTTParty::Response, to_json: '{}'))
  end
end
