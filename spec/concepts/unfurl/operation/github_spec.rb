# frozen_string_literal: true

require 'rails_helper'

describe Unfurl::Github do
  context 'with public github pr' do
    before do
      allow(SiteMeta).to receive(:from_url).and_return(meta)
    end

    subject { described_class.call(params) }

    let(:params) do
      { url: 'https://github.com/react-toolbox/react-toolbox/pull/1719' }
    end

    let(:meta) do
      { description: "Fixes #1715, Fixes #1703\n\nremove references to React.PropTypes\nfixed other removed imports\n\nNote: Meant to be based on tag:1.3.4",
        favicon: 'https://github.com/favicon.ico',
        image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
        site_name: 'GitHub',
        title: 'v1 react16 compat by bionikspoon · Pull Request #1719 · react-toolbox/react-toolbox',
        type: 'object',
        url: 'https://github.com/react-toolbox/react-toolbox/pull/1719' }
    end

    let(:unfurl) do
      {
        author_icon: 'https://github.com/favicon.ico',
        author_link: 'https://github.com/react-toolbox/react-toolbox/pull/1719',
        author_name: 'GitHub',
        description: "Fixes #1715, Fixes #1703\n\nremove references to React.PropTypes\nfixed other removed imports\n\nNote: Meant to be based on tag:1.3.4",
        favicon: 'https://github.com/favicon.ico',
        image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
        site_name: 'GitHub',
        text: "Fixes #1715, Fixes #1703\n\nremove references to React.PropTypes\nfixed other removed imports\n\nNote: Meant to be based on tag:1.3.4",
        thumb_url: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
        title: 'v1 react16 compat by bionikspoon · Pull Request #1719 · react-toolbox/react-toolbox',
        title_link: 'https://github.com/react-toolbox/react-toolbox/pull/1719',
        type: 'object',
        url: 'https://github.com/react-toolbox/react-toolbox/pull/1719'
      }
    end

    it { is_expected.to be_success }
    its([:unfurl]) { is_expected.to eq(unfurl) }
  end
end
