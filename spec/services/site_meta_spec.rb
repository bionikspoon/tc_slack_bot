# frozen_string_literal: true

require 'rails_helper'

describe SiteMeta do
  def self.test_extraction(name, fixture, expected)
    context "when converting meta data to a hash [#{name}]" do
      subject { described_class.call(html) }

      let(:html) { file_fixture(fixture).read }

      it { is_expected.to eq expected }
    end
  end

  test_extraction(
    'pr',
    'github/pr.html',
    description: "Fixes #1715, Fixes #1703\n\nremove references to React.PropTypes\nfixed other removed imports\n\nNote: Meant to be based on tag:1.3.4",
    image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
    site_name: 'GitHub',
    title: 'v1 react16 compat by bionikspoon · Pull Request #1719 · react-toolbox/react-toolbox',
    type: 'object',
    url: 'https://github.com/react-toolbox/react-toolbox/pull/1719',
    favicon: 'https://assets-cdn.github.com/favicon.ico'
  )

  test_extraction(
    'profile',
    'github/profile.html',
    description: 'bionikspoon has 153 repositories available. Follow their code on GitHub.',
    image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
    site_name: 'GitHub',
    title: 'bionikspoon (Manu Phatak)',
    type: 'profile',
    url: 'https://github.com/bionikspoon',
    favicon: 'https://assets-cdn.github.com/favicon.ico'
  )

  test_extraction(
    'index',
    'github/index.html',
    description: 'GitHub is where people build software. More than 26 million people use GitHub to discover, fork, and contribute to over 74 million projects.',
    image: 'https://assets-cdn.github.com/images/modules/open_graph/github-octocat.png',
    'image:height': '620',
    'image:width': '1200',
    'image:type': 'image/png',
    site_name: 'GitHub',
    title: 'Build software better, together',
    url: 'https://github.com',
    favicon: 'https://assets-cdn.github.com/favicon.ico'
  )
end
