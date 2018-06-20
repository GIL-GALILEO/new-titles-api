# frozen_string_literal: true

require 'rails_helper'

describe TitlesController, type: :request do
  context 'without authorization' do
    it 'returns appropriate HTTP response' do
      get new_titles_path
      expect(response.code).to eq '401'
    end
  end
  context 'with authorization' do
    let(:title) { Fabricate :title }
    let :headers do
      { 'X-User-Token' => Institution.find(1).api_key }
    end
    it 'returns JSON for a title' do
      get new_titles_path,
          params: {},
          headers: { 'X-User-Token' => Institution.find(1).api_key }
      expect(response.code).to eq '200'
    end
  end
end