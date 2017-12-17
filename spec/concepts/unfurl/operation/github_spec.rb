# frozen_string_literal: true

require 'rails_helper'

describe Unfurl::Github do
  context 'with public github url' do
    before do
      allow(SiteMeta).to receive(:from_url).and_return(meta)
    end

    subject { described_class.call(url: url) }

    let(:url) { 'https://github.com/bionikspoon' }

    let(:meta) do
      {
        description: 'bionikspoon has 153 repositories available. Follow their code on GitHub.',
        image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
        site_name: 'GitHub',
        title: 'bionikspoon (Manu Phatak)',
        type: 'profile',
        url: 'https://github.com/bionikspoon',
        favicon: 'https://github.com/favicon.ico'
      }
    end

    let(:unfurl) do
      {
        footer_icon: 'https://github.com/favicon.ico',
        footer: 'GitHub',
        text: 'bionikspoon has 153 repositories available. Follow their code on GitHub.',
        thumb_url: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
        title_link: 'https://github.com/bionikspoon',
        title: 'bionikspoon (Manu Phatak)'
      }
    end

    it { is_expected.to be_success }
    its([:unfurl]) { is_expected.to eq(unfurl) }
  end
  context 'with private pr' do
    subject { described_class.call(url: url) }

    before { allow(API::Github).to receive(:pr).and_return(JSON.parse(json).deep_symbolize_keys) }
    let(:json) { file_fixture('github/pr.json').read }
    let(:unfurl) do
      {
        author_icon: 'https://avatars3.githubusercontent.com/u/5052422?v=4',
        author_link: 'https://github.com/bionikspoon',
        author_name: 'bionikspoon',
        fallback: '[open] More grades: New School class [#153636648] · Pull Request 3813 · ThinkCERCA/thinkCERCA',
        footer: 'Github',
        footer_icon: 'https://github.com/favicon.ico',
        mrkdwn_in: %i[text fields pretext],
        text: 'I like turtles.',
        title: '[open] More grades: New School class [#153636648] · Pull Request 3813 · ThinkCERCA/thinkCERCA',
        title_link: 'https://github.com/ThinkCERCA/thinkCERCA/pull/3813',
        fields: [
          { title: 'Changes', value: '+3 / -1 / 1 file', short: true },
          { title: 'Branch', value: '`153636648_grades__new_class`', short: true },
          { title: 'Pivotal', value: 'https://pivotaltracker.com/story/show/153636648', short: false }
        ]
      }
    end
    let(:url) { 'https://github.com/thinkCERCA/thinkcerca/pull/1' }

    it { is_expected.to be_success }
    its([:unfurl]) { is_expected.to eq(unfurl) }
  end
end
