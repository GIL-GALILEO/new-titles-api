# frozen_string_literal: true

require 'rails_helper'
require 'httparty'

describe 'AlmaReportsApi' do
  let(:uri) do
    'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/analytics/reports?%23%5BDouble%20%22A%20Query%22%5D'
  end
  let(:institution){ double('An Institution', shortcode: 'test') }
  let(:query) { double('A Query', empty?: false) }

  describe('::call') do
    describe 'success' do
      before do
        stub_request(:get, uri)
          .with(headers: { 'Authorization' => 'apikey' })
          .to_return(status: 200, body: '', headers: {})
      end

      subject(:api_response) { AlmaReportsApi.call(query, institution) }
      it 'gets a successful response' do
        expect(api_response.success?).to be true
      end
    end
    describe 'fail' do
      let(:institution) { double('An Institution', shortcode: 'test') }
      let(:notifier) { double('A Notifier') }
      before do
        allow(notifier). to receive(:ping)
      end
      describe 'When a ReadTimeout is raised' do
        before do
          stub_request(:get, uri)
            .with(headers: { 'Authorization'=>'apikey' })
            .to_raise Net::ReadTimeout
        end
        it "sends a message to reporting when all of it's retries are used" do
          AlmaReportsApi.call(query, institution, notifier: notifier)
          expect(notifier).to have_received(:ping).with(/ReadTimeout/)
        end
      end
      describe 'When an OpenTimeout is raised' do
        before do
          stub_request(:get, uri)
              .with(headers: { 'Authorization'=>'apikey' })
              .to_raise Net::OpenTimeout
        end
        it "sends a message to reporting when all of it's retries are used" do
          AlmaReportsApi.call(query, institution, notifier: notifier)
          expect(notifier).to have_received(:ping).with(/OpenTimeout/)
        end
      end
      describe 'unauthorized' do
        let(:body) { file_fixture('error_wrong_key.xml').read }
        let(:xml_error_message) do
          Nokogiri::XML(body).css('errorList error errorMessage').text
        end
        before do
          stub_request(:get, uri)
            .with(headers: { 'Authorization' => 'apikey' })
            .to_return(status: 400, body: body)
        end
        it 'sends a message to reporting when wrong api key is used' do
          AlmaReportsApi.call(query, institution, notifier: notifier)
          expect(notifier).to have_received(:ping).with(/#{xml_error_message}/)
        end
      end
    end

  end
  describe('::parse_error') do
    let(:body) { file_fixture('error_response.xml').read }
    let(:xml_errors) {
      Nokogiri::XML(body).remove_namespaces!.css('errorList error')
    }
    subject(:parsed_errors) { AlmaReportsApi.parse_error body }
    it 'has the correct number of errors' do
      expect(parsed_errors.size).to eql xml_errors.size
    end
  end
  describe('::error_message') do
    let(:body) { file_fixture('error_response.xml').read }
    let(:response) { double('A response', code: '500', body: body) }
    let(:institution) { 'uga' }
    let(:query) { { path: 'Test/path'} }
    subject(:message) {
      AlmaReportsApi.error_message(response, institution, query)
    }
    it 'returns an error message with the correct http code' do
      expect(message).to include("status: 500")
    end
    it 'returns an error message with the correct institution' do
      expect(message).to include(institution)
    end
    it 'returns an error message with the correct query' do
      expect(message).to include(query.to_s)
    end
  end

end