# frozen_string_literal: true

require 'rails_helper'

describe ReportParser do
  let(:institution) { Institution.find(1) }
  context 'physical items' do
    let :sample_row_xml_physical do
      Nokogiri::XML('
      <Row>
        <Column0>0</Column0>
        <Column1>Cresswell, Lyell, 1944-</Column1>
        <Column2>1845696360; 9781845696368; 0857093703; 9780857093707</Column2>
        <Column3>9921223233902959</Column3>
        <Column4>9910010409402931</Column4>
        <Column5>1980?-</Column5>
        <Column6>The Department</Column6>
        <Column7>Education--United States--Periodicals.</Column7>
        <Column8>No</Column8>
        <Column9>American education /</Column9>
        <Column10>3ed 0000001.0000010</Column10>
        <Column11>J84: ED 1.10:</Column11>
        <Column12>Unknown</Column12>
        <Column13>Map &amp; Government Information Library - US Documents</Column13>
        <Column14>Main Library</Column14>
        <Column15>2Gov Main</Column15>
        <Column16>Issue</Column16>
        <Column17>2018-06-25</Column17>
      </Row>').xpath('//Row').first
    end
    it 'creates a physical title' do
      title = ReportParser.title_from institution, sample_row_xml_physical, 'physical'
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
  end
  context 'electronic items' do
    let :sample_row_xml_electronic do
      Nokogiri::XML('
      <Row>
        <Column0>0</Column0>
        <Column1>Georgia. Department of Community Affairs, author.</Column1>
        <Column2></Column2>
        <Column3>DU80</Column3>
        <Column4>9949118973502959</Column4>
        <Column5>9915366542602931</Column5>
        <Column6>2004-</Column6>
        <Column7>Georgia Department of Community Affairs</Column7>
        <Column8>Georgia.--Department of Community Affairs--Periodicals.; Community development--Georgia--Periodicals.;</Column8>
        <Column9>No</Column9>
        <Column10>DCA building communities.</Column10>
        <Column11>DOAJ Directory of Open Access Journals</Column11>
        <Column12>2018-06-25</Column12>
        <Column13>Journal</Column13>
      </Row>').xpath('//Row').first
    end
    it 'creates a electronic Title' do
      title = ReportParser.title_from institution, sample_row_xml_electronic, 'electronic'
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