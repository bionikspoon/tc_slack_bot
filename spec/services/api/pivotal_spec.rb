# frozen_string_literal: true

require 'rails_helper'

describe API::Pivotal, type: :services do
  before { stub_const('PIVOTAL_TOKEN', 'secret') }

  let(:headers) do
    {
      'Content-Type' => 'application/json; charset=utf-8',
      'X-TrackerToken' => 'secret'
    }
  end

  describe 'story' do
    after { API::Pivotal.story(151_356_728) }

    before do
      allow(API::Pivotal).to receive(:get)
        .and_return(double(body: '{}'))
    end

    it 'sends get with params' do
      expect(API::Pivotal).to receive(:get).with(
        '/stories/151356728',
        headers: headers
      )
    end
  end

  describe 'my_people' do
    after { API::Pivotal.my_people(2_148_385) }

    it 'sends get with params' do
      expect(API::Pivotal).to receive(:get).with(
        '/my/people',
        headers: headers,
        query: { project_id: 2_148_385 }
      ).and_return(double(body: '{}'))
    end
  end

  describe 'find_my_people' do
    subject { API::Pivotal.find_my_people(2_148_385, [3_333_333, 2_222_222]) }

    before { allow(API::Pivotal).to receive(:my_people).and_return(my_people) }

    let(:my_people) do
      [
        { person: { id: 1_111_111, username: 'tcbot' } },
        { person: { id: 2_222_222, username: 'manuphatak' } },
        { person: { id: 3_333_333, username: 'marketing' } }
      ]
    end
    let(:interesting_people) do
      [
        { person: { id: 3_333_333, username: 'marketing' } },
        { person: { id: 2_222_222, username: 'manuphatak' } }
      ]
    end

    it { is_expected.to eq(interesting_people) }
  end
end
