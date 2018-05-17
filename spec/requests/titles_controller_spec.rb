# frozen_string_literal: true

require 'rails_helper'

describe 'New Titles API' do
  context 'with one record' do
    it 'return JSON for the single title with plain request' do
      title = Fabricate :title
      get '/new_titles'
      expect(response.code).to eq '200'
      parsed_response = JSON.parse(response.body)[0]
      expect(parsed_response['title']).to eq title.title
      expect(parsed_response['author']).to eq title.author
      expect(parsed_response['mms_id']).to eq title.mms_id
      expect(parsed_response).not_to have_key :id
    end
  end
  context 'with a date parameter' do
    it 'only returns expected item' do
      Fabricate(:title, receiving_date: Date.today - 20)
      new_title = Fabricate :title
      get '/new_titles/15' # new titles in the last 15 days
      parsed_response = JSON.parse response.body
      expect(parsed_response.length).to eq 1
      expect(parsed_response[0]['title']).to eq new_title.title
    end
  end
end