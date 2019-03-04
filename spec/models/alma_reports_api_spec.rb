# frozen_string_literal: true

require 'rails_helper'
require 'httparty'

describe 'AlmaReportsApi' do
  let(:uri) do
    "https://api-eu.hosted.exlibrisgroup.com/almaws/v1/analytics/reports?%23%5BDouble%20%22A%20Query%22%5D"
  end
  let(:institution){double('An Institution', shortcode: 'test')}
  let(:query) {double('A Query', empty?: false)}

  describe('::call') do
    describe 'success' do
      before do
        stub_request(:get, uri)
          .with(headers: {'Authorization'=>'apikey'})
          .to_return(status: 200, body: '', headers: {})
      end

      subject(:api_response) { AlmaReportsApi.call(query, institution) }
      it 'gets a successful response' do
        expect(api_response.success?).to be true
      end
    end
    describe 'fail' do
      before do
        stub_request(:get, uri)
          .with(headers: {'Authorization'=>'apikey'})
          .to_timeout
      end

      let(:institution){ double('An Institution', shortcode: 'test') }
      it "it raises an error when it's used up all of it's retries" do
        expect { AlmaReportsApi.call(query, institution) }
          .to raise_error(StandardError, /MAX_RETRIES exhausted/)
      end
    end

  end


end