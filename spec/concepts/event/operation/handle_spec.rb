require 'rails_helper'

describe Event::Handle do
  before { stub_const('SLACK_TOKEN', 'secret') }

  subject { described_class.call(params) }

  let(:status) { subject[:status] }

  context 'with valid params' do
    let(:params) do
      {
        token: 'secret',
        challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
        type: 'url_verification'
      }
    end

    it { is_expected.to be_success }
  end

  context 'with invalid params' do
    let(:params) do
      { hello: 'world', token: 'secret' }
    end

    it { is_expected.to be_failure }
    it { expect(status).to eq :unprocessable_entity }
  end

  context 'with unauthorized params' do
    let(:params) do
      {
        token: 'fake_token',
        challenge: '3eZbrw1aBm2rZgRNFdxV2595E9CY3gmdALWMmHkvFXO7tYXAYM8P',
        type: 'url_verification'
      }
    end

    it { is_expected.to be_failure }
    it { expect(status).to eq :unauthorized }
  end
end
