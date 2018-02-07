# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'routing' do
    it 'routes to #test' do
      expect(get: '/test').to route_to 'application#test'
    end
  end
end