# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :routing do
  describe 'routing' do
    subject { { post: '/events' } }

    it { is_expected.to route_to('events#create') }
  end
end
