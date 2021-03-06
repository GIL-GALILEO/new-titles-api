# frozen_string_literal: true

require 'rails_helper'

describe Title do
  context 'basic attributes' do
    it 'has a name' do
      expect(Institution.new).to respond_to :name
    end
    it 'has a institution code' do
      expect(Institution.new).to respond_to :institution_code
    end
    it 'has a image' do
      expect(Institution.new).to respond_to :image
    end
    it 'has an api key' do
      expect(Institution.new).to respond_to :api_key
    end
  end
  context 'api auth functionality' do
    let(:institution) { Institution.new(institution_code: 'GALI') }
    it 'has an api_key' do
      expect(institution.api_key).to eq 'GALI_key'
    end
    context 'in production' do
      it 'has a production API key' do
        allow(Rails).to receive(:env) { 'production'.inquiry }
        expect(institution.api_key.length).to eq 32
      end
    end
  end
  context 'sync functionality' do
    it 'expires a title more than 90 days old' do
      Fabricate(:title, created_at: Time.now - 100.days)
      outcome = Title.expire_titles(Title.last.institution)
      expect(outcome).to eq 1
      expect(Title.count).to eq 0
    end
    it 'does not expire a less than 90 days old' do
      Fabricate(:title, created_at: Time.now - 40.days)
      Title.expire_titles(Title.last.institution)
      expect(Title.count).to eq 1
    end
  end

end