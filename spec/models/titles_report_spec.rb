# frozen_string_literal: true

require 'rails_helper'

describe 'TitlesReport' do
  describe '::initialize' do
    let(:institution) { double('An Institution') }
    context 'when report_override is nil' do
      let(:type) { 'Electronic' }
      subject(:titles_report) do
        TitlesReport.new(institution, type: type)
      end
      it 'has the correct report type' do
        expect(titles_report.report_type).to eql('New Titles Electronic')
      end
    end
    context 'when report_override is provided' do
      let(:override) { 'New Titles Physical - Temp Location' }
      subject(:titles_report) do
        TitlesReport.new(institution, report_override: override)
      end
      it 'has the correct report_type' do
        expect(titles_report.report_type).to eql(override)
      end
    end
  end
  describe '.create' do
    # TODO: SN 3/4/19, Need to find alternative to getting an Institution from active record.
    # However, this will involve restructuring report_parser.rb
    let(:institution) do
      Institution.find_by_shortcode('uga')
    end
    context 'new titles physical ' do
      let(:xml_doc) { file_fixture('response_physical_no_token.xml').read }
      let(:xml_rows) { Nokogiri::XML(xml_doc).remove_namespaces!.xpath('//Row') }
      let(:dbl_api) do
        api = double('An API')
        allow(api).to receive(:call)
          .and_return(double('A response from an API',
                             success?: true,
                             body: xml_doc))
        api
      end
      subject(:report) do
        TitlesReport.new(institution, type: 'Physical', api: dbl_api).create
      end
      it 'extracts the same number of rows as in the xml' do
        expect(report.titles.size).to eq(xml_rows.size)
      end
      it 'has the same first title as the xml response' do
        title = xml_rows.xpath('//Column9').first.text
        expect(report.titles.first.title).to eql title
      end
      it 'has the same last title as the xml response' do
        title = xml_rows.xpath('//Column9').last.text
        expect(report.titles.last.title).to include title
      end
    end
    context 'new titles electronic ' do
      let(:xml_doc) { file_fixture('response_electronic_no_token.xml').read }
      let(:xml_rows) { Nokogiri::XML(xml_doc).remove_namespaces!.xpath('//Row') }
      let(:dbl_api) do
        api = double('An API')
        allow(api).to receive(:call)
          .and_return(double('A response from an API',
                             success?: true,
                             body: xml_doc))
        api
      end
      subject(:report) do
        TitlesReport.new(institution, type: 'Electronic', api: dbl_api).create
      end
      it 'extracted the same number of rows as in the xml' do
        expect(report.titles.size).to eq(xml_rows.size)
      end
      it 'has the first title from the xml response' do
        title = xml_rows.xpath('//Column10').first.text
        expect(report.titles.first.title).to eql title
      end
      it 'has the last title from the xml response' do
        title = xml_rows.xpath('//Column10').last.text
        expect(report.titles.last.title).to eql title
      end
    end

    context 'unsuccessful' do
      it 'throws error when receives unsuccessful response from api' do
        dbl_response = double('A response from an API',
                              success?: false,
                              message: 'dbl_response')
        dbl_api = double('An API')
        allow(dbl_api).to receive(:call).and_return(dbl_response)

        expect do
          TitlesReport.new(Institution.find_by_shortcode('uga'), api: dbl_api)
                      .create
        end.to raise_error(/dbl_response/)
      end
      context 'failed rows' do
        let(:xml_doc) { file_fixture('response_physical_no_token.xml').read }
        let(:api) {
          api = double('An API')
          allow(api).to receive(:call)
            .and_return(double('A response from an API',
                               success?: true,
                               body: xml_doc))
          api
        }
        subject(:titles) {
          TitlesReport.new(institution, type: '!Bad_Medium!', api: api).create
        }
        it 'has failed rows when a bad medium is supplied' do
          expect(titles.failed_rows).not_to be_empty
        end
        it 'has failed rows with a medium not supported message' do
          expect(titles.failed_rows.sample[:message])
            .to include('medium not supported')
        end
      end
    end
  end
end