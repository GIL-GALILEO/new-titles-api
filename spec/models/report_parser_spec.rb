# frozen_string_literal: true

require 'rails_helper'

describe ReportParser do
  let(:institution) { Fabricate(:institution) }
  describe '::title_from' do
    context 'successful' do
      context 'physical medium items' do
        let(:xml_doc) { file_fixture('row_physical.xml').read }
        let(:xml_row_physical) { Nokogiri::XML(xml_doc).css('Row').first }

        it 'creates a physical title' do
          title = ReportParser.title_from institution, xml_row_physical, 'physical'
          expect(title.institution).to                    eq institution
          expect(title.title).to                          eq 'American education /'
          expect(title.author).to                         eq 'Cresswell, Lyell, 1944-'
          expect(title.publisher).to                      eq 'The Department'
          expect(title.call_number).to                    eq 'J84: ED 1.10:'
          expect(title.library).to                        eq 'Main Library'
          expect(title.location).to                       eq 'Map & Government Information Library - US Documents'
          expect(title.material_type).to                  eq 'Issue'
          expect(title.receiving_date).to                 eq Date.new(2018, 6, 25)
          expect(title.mms_id).to                         eq '9921223233902959'
          expect(title.subjects).to                       eq 'Education--United States--Periodicals.'
          expect(title.isbn).to                           eq '1845696360; 9781845696368; 0857093703; 9780857093707'
          expect(title.publication_date).to               eq '1980?-'
          expect(title.portfolio_name).to                 be_nil
          expect(title.portfolio_activation_date).to      be_nil
          expect(title.portfolio_creation_date).to        be_nil
          expect(title.classification_code).to            eq 'Unknown'
          expect(title.availability).to                   be_nil
        end
        context 'xml row has a temporary_location column' do
          let(:xml_temp) { file_fixture('row_physical_temp_location.xml').read }
          let(:xml_row) { Nokogiri::XML(xml_temp).css('Row').first }
          it 'creates a title with a location equal to the temporary location' do
            temp_location = xml_row.css('Column18').text
            title = ReportParser.title_from institution, xml_row, 'physical'
            expect(title.location).to eq temp_location
          end
        end

      end
      context 'electronic medium items' do
        let(:xml_doc) { file_fixture('row_electronic.xml').read }
        let(:xml_row_electronic) { Nokogiri::XML(xml_doc).css('Row').first }

        it 'creates a electronic Title' do
          title = ReportParser.title_from institution, xml_row_electronic, 'electronic'
          expect(title.institution).to                    eq institution
          expect(title.title).to                          eq 'DCA building communities.'
          expect(title.author).to                         eq 'Georgia. Department of Community Affairs, author.'
          expect(title.publisher).to                      eq 'Georgia Department of Community Affairs'
          expect(title.call_number).to                    eq 'DU80'
          expect(title.library).to                        be_nil
          expect(title.location).to                       be_nil
          expect(title.material_type).to                  eq 'Journal'
          expect(title.receiving_date).to                 eq Date.new(2018, 6, 25)
          expect(title.mms_id).to                         eq '9949118973502959'
          expect(title.subjects).to                       eq 'Georgia.--Department of Community Affairs--Periodicals.; Community development--Georgia--Periodicals.;'
          expect(title.isbn).to                           eq ''
          expect(title.publication_date).to               eq '2004-'
          expect(title.portfolio_name).to                 eq 'DOAJ Directory of Open Access Journals'
          expect(title.portfolio_activation_date).to      eq Date.new(2018, 6, 25)
          expect(title.portfolio_creation_date).to        be_nil
          expect(title.classification_code).to            be_nil
          expect(title.availability).to                   be_nil
        end
      end
    end
    context 'unsuccessful' do
      let(:medium) { '!Bad medium type!' }
      let(:xml_row) { double('An xml row')}
      it 'raises an error when a report type is unsupported' do
        expect { ReportParser.title_from(institution, xml_row, medium) }
          .to raise_error(ArgumentError, /medium/)
      end
    end
  end
  describe '::date_from' do
    context 'Valid Date' do
      it 'returns Date when given a YYYY-MM-DD string' do
        expect(ReportParser.date_from('2019-02-28')).to eq Date.new(2019, 02, 28)
      end
      it 'returns Date when given a in YYYY string' do
        expect(ReportParser.date_from('9999')).to eq Date.new(9999, 1, 1)
      end
      it 'returns Date when given a in YYYY string with extra characters' do
        expect(ReportParser.date_from('A-19B.89C:')).to eq Date.new(1989, 1, 1)
      end
    end
    context 'Invalid Date' do
      it 'returns nil when given nil' do
        expect(ReportParser.date_from(nil)).to be_nil
      end
      it 'returns nil when given a five character wrong date with hyphen' do
        expect(ReportParser.date_from('55-555')).to be_nil
      end
      it 'returns nil when given a date that does not exist' do
        expect(ReportParser.date_from('2019-02-29')).to be_nil
      end
    end
  end
  describe '::finalize_location' do
    describe 'location should update' do
      let(:location) { 'original' }
      let(:temp_location) { 'New location' }
      let(:data) { { location: location, temporary_location: temp_location } }

      it 'updates location with valid temporary_location' do
        ReportParser.finalize_location(data)
        expect(data[:location]).to eq temp_location
      end
      it 'removes the temporary_location key from the hash' do
        ReportParser.finalize_location(data)
        expect(data).not_to have_key(:temporary_location)
      end
    end

    describe 'location should not update' do
      let(:location) { 'original' }
      let(:data) { { location: location } }

      it 'does not update location when :temporary_location is not a key' do
        ReportParser.finalize_location(data)
        expect(data[:location]).to eq location
      end
      it 'does not update location when :temporary_location is none' do
        data[:temporary_location] = 'none'
        ReportParser.finalize_location(data)
        expect(data[:location]).to eq location
      end
      it 'does not update location when :temporary_location is only whitespace' do
        data[:temporary_location] = '   '
        ReportParser.finalize_location(data)
        expect(data[:location]).to eq location
      end
      it 'does not update location when :temporary_location is nil' do
        data[:temporary_location] = nil
        ReportParser.finalize_location(data)
        expect(data[:location]).to eq location
      end
      it "still removes the temporary_location when it's value is invalid" do
        data[:temporary_location] = 'None'
        ReportParser.finalize_location(data)
        expect(data).not_to have_key(:temporary_location)
      end
    end
  end
end
