# frozen_string_literal: true

require 'rails_helper'

describe 'TitlesReport' do
  describe '::initialize' do
    let(:institution) {double("An Institution")}
    context 'when report_override is nil' do
      let(:type) { 'Electronic' }
      subject(:titles_report) {
        TitlesReport.new(institution,type: type)
      }
      it 'has the correct report type' do
        expect(titles_report.report_type).to eql('New Titles Electronic')
      end
    end
    context 'when report_override is provided' do
      let(:override) {'New Titles Electronic'}
      subject(:titles_report) {
        TitlesReport.new(institution, report_override: override)
      }
      it 'has the correct report_type' do
        expect(titles_report.report_type).to eql(override)
      end
    end
    context 'unsuccessful' do
      let(:override) {'!Bad report type!'}
      it 'raises an error when a report type is unsupported' do
        expect { TitlesReport.new(institution, report_override: override) }
          .to raise_error(ArgumentError, /report_type/)
      end
    end
  end
  describe '.create' do
    # TODO: SN 3/4/19, Need to find alternative to getting an Institution from active record.
    # However, this will involve restructuring report_parser.rb
    let(:institution){
      Institution.find_by_shortcode('uga')
    }
    context 'new titles physical ' do
      let(:xml_doc) { file_fixture('response_physical_no_token.xml').read }
      let(:xml_rows) { Nokogiri::XML(xml_doc).remove_namespaces!.xpath('//Row') }
      let(:dbl_api){
        api = double('An API')
        allow(api).to receive(:call)
          .and_return(double('A response from an API',
                             success?: true,
                             body: xml_doc))
        api
      }
      subject(:report) {
        TitlesReport.new(institution, type: 'Physical', api: dbl_api).create
      }
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
      let(:dbl_api){
        api = double('An API')
        allow(api).to receive(:call)
                        .and_return(double('A response from an API',
                                           success?: true,
                                           body: xml_doc))
        api
      }
      subject(:report) {
        TitlesReport.new(institution, type: 'Electronic', api: dbl_api).create
      }
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

        expect{
          TitlesReport.new(Institution.find_by_shortcode('uga'), api: dbl_api)
                      .create
        }.to raise_error(/dbl_response/)
      end
    end
  end
end