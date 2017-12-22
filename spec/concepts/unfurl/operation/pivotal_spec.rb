# frozen_string_literal: true

require 'rails_helper'

describe Unfurl::Pivotal do
  describe '#call' do
    context 'with public url' do
      before do
        allow(SiteMeta).to receive(:from_url).and_return(meta)
      end

      subject { described_class.call(url: url) }

      let(:url) { 'https://pivotaltracker.com/' }

      let(:meta) do
        {
          description: "Pivotal Tracker: The awesome, lightweight, agile project management tool for software teams. Get your 30-day Free Trial started today!\n",
          image: 'https://www.pivotaltracker.com/marketing_assets/tracker-1-445dc92b9bf372cdab2d97b0a032866e7d1e1cc9565060e223c56d27292a6973.png',
          type: 'website',
          title: 'Agile Project Management',
          url: 'https://www.pivotaltracker.com/',
          favicon: 'https://www.pivotaltracker.com/favicon.ico'
        }
      end

      let(:unfurl) do
        {
          footer_icon: 'https://www.pivotaltracker.com/favicon.ico',
          footer: 'Pivotal',
          text: "Pivotal Tracker: The awesome, lightweight, agile project management tool for software teams. Get your 30-day Free Trial started today!\n",
          thumb_url: 'https://www.pivotaltracker.com/marketing_assets/tracker-1-445dc92b9bf372cdab2d97b0a032866e7d1e1cc9565060e223c56d27292a6973.png',
          title_link: 'https://www.pivotaltracker.com/',
          title: 'Agile Project Management'
        }
      end

      it { is_expected.to be_success }
      its([:unfurl]) { is_expected.to eq(unfurl) }
    end

    context 'with private story' do
      subject { described_class.call(url: url) }

      before { allow(API::Pivotal).to receive(:story).and_return(JSON.parse(json, symbolize_names: true)) }
      let(:json) { file_fixture('pivotal/story.json').read }

      let(:unfurl) do
        {
          footer_icon: 'https://pivotaltracker.com/favicon.ico',
          footer: 'Pivotal',
          color: 'e0e2e5',
          mrkdwn_in: %i[text fields],
          text: 'Really need this story to test things',
          title_link: 'https://www.pivotaltracker.com/story/show/151356728',
          title: 'Test Story · #151356728',
          fields: [
            { title: 'Labels', value: '`critical` `qa by dev` `test`', short: false }
          ]
        }
      end
      let(:url) { 'https://www.pivotaltracker.com/story/show/151356728' }

      it { is_expected.to be_success }
      its([:unfurl]) { is_expected.to eq(unfurl) }
    end
  end
end
