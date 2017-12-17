# frozen_string_literal: true

require 'rails_helper'

describe SiteMeta do
  describe 'call' do
    def self.test_extraction(fixture, expected)
      context "when converting meta data to a hash [#{fixture}]" do
        subject { described_class.call(html) }

        let(:html) { file_fixture(fixture).read }

        it { is_expected.to eq expected }
      end
    end

    test_extraction(
      'github/pr.html',
      description: "Fixes #1715, Fixes #1703\n\nremove references to React.PropTypes\nfixed other removed imports\n\nNote: Meant to be based on tag:1.3.4",
      image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
      site_name: 'GitHub',
      title: 'v1 react16 compat by bionikspoon · Pull Request #1719 · react-toolbox/react-toolbox',
      type: 'object',
      url: 'https://github.com/react-toolbox/react-toolbox/pull/1719',
      favicon: 'https://github.com/favicon.ico'
    )

    test_extraction(
      'github/profile.html',
      description: 'bionikspoon has 153 repositories available. Follow their code on GitHub.',
      image: 'https://avatars3.githubusercontent.com/u/5052422?s=400&v=4',
      site_name: 'GitHub',
      title: 'bionikspoon (Manu Phatak)',
      type: 'profile',
      url: 'https://github.com/bionikspoon',
      favicon: 'https://github.com/favicon.ico'
    )

    test_extraction(
      'github/index.html',
      description: 'GitHub is where people build software. More than 26 million people use GitHub to discover, fork, and contribute to over 74 million projects.',
      image: 'https://assets-cdn.github.com/images/modules/open_graph/github-octocat.png',
      'image:height': '620',
      'image:width': '1200',
      'image:type': 'image/png',
      site_name: 'GitHub',
      title: 'Build software better, together',
      url: 'https://github.com',
      favicon: 'https://github.com/favicon.ico'
    )

    test_extraction(
      'pivotal/index.html',
      description: "Pivotal Tracker: The awesome, lightweight, agile project management tool for software teams. Get your 30-day Free Trial started today!\n",
      image: 'https://www.pivotaltracker.com/marketing_assets/tracker-1-445dc92b9bf372cdab2d97b0a032866e7d1e1cc9565060e223c56d27292a6973.png',
      type: 'website',
      title: 'Agile Project Management',
      url: 'https://www.pivotaltracker.com/',
      favicon: 'https://www.pivotaltracker.com/favicon.ico'
    )

    test_extraction(
      'pivotal/blog.html',
      description: 'One of the most striking things that nearly all highly effective teams have in common is a small—but reasonable—set of clearly defined goals for each iterati...',
      image: 'https://www.pivotaltracker.comhttps://marketing-assets.pivotaltracker.com/marketing_assets/blog/2017/sunset-846f9e135c0604ba4284daa3b958669718bf2b56746dd6d3bf6d41bd4c70e1c3.png',
      type: 'website',
      title: 'Keeping Your Team on Track',
      url: 'https://www.pivotaltracker.com/blog/keeping-your-team-on-track/',
      favicon: 'https://www.pivotaltracker.com/favicon.ico'
    )
  end

  describe 'from_url' do
    let(:html) { file_fixture('github/pr.html').read }

    before do
      response = double(body: html)
      allow(HTTParty).to receive(:get).and_return(response)
    end

    it "calls 'call' with html" do
      expect(described_class).to receive(:call).with(html)

      described_class.from_url('https://github.com/react-toolbox/react-toolbox/pull/1719')
    end
  end
end
