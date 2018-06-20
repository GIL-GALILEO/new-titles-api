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
    let(:institution) { Institution.find(1) }
    let(:headers) { { 'X-User-Token' => institution.api_key } }
    it 'returns JSON for a title' do
      title = Fabricate(:title, institution: institution)
      get new_titles_path,
          params: {},
          headers: headers
      expect(response.code).to eq '200'
      expect(JSON.parse(response.body)[0]['title']).to eq title.title
      expect(JSON.parse(response.body)[0]['inst_name']).to eq institution.name
    end
    it 'returns only titles for a specified media type' do
      Fabricate(:title, material_type: 'DVD')
      get new_titles_path,
          params: { media_type: 'DVD' },
          headers: headers
      expect(JSON.parse(response.body)[0]['material_type']).to eq 'DVD'
    end
  end
end