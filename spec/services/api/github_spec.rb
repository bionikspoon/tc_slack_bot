# frozen_string_literal: true

require 'rails_helper'

describe API::Github, type: :services do
  describe '#pr' do
    after { described_class.pr('thinkCERCA', 'thinkCERCA', 1) }

    it 'sends post with params' do
      expect(described_class).to receive(:get)
        .with('/repos/thinkCERCA/thinkCERCA/pulls/1', {})
        .and_return(instance_double(HTTParty::Response, to_json: '{}'))
    end
  end
end
