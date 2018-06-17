# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitlesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/new_titles/').to route_to controller: 'titles', action: 'index'
    end
  end
end