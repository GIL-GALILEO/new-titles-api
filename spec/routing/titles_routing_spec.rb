# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitlesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/new_titles/60/').to route_to controller: 'titles', action: 'index', days: '60'
      expect(get: '/new_titles/60/dvd').to route_to controller: 'titles', action: 'index', days: '60', media: 'dvd'
    end
  end
end