# frozen_string_literal: true

require 'rails_helper'

describe ReportParser do
  context 'physical items' do
    let :sample_row_xml_physical do
      Nokogiri::XML('<Row>
        <Column0>0</Column0>
        <Column2>1911054163; 9781911054160</Column2>
        <Column3>9949111174002959</Column3>
        <Column4>2017.</Column4>
        <Column5>National Galleries of Scotland</Column5>
        <Column6>Art, Scottish--20th century--Exhibitions.; Modernism (Art)--Scotland--Exhibitions.; Art, Scottish.; Modernism (Art); Scotland.; 1900-1999; Exhibition catalogs.</Column6>
        <Column7>A new era : Scottish modern art, 1900-1950 /</Column7>
        <Column8>N6779.5.M63 N49 2017</Column8>
        <Column9>N</Column9>
        <Column10>01GALI_UGA</Column10>
        <Column11>University of Georgia</Column11>
        <Column12>Main Library</Column12>
        <Column13>1On Order for Stacks</Column13>
        <Column14>Book</Column14>
        <Column15>2018-05-14</Column15>
      </Row>').xpath('//Row').first
    end
    it 'creates a physical title' do
      title = ReportParser.title_from sample_row_xml_physical, 'physical'
      expect(title.receiving_date).to eq Date.new(2018, 5, 14)
    end
  end
  context 'electronic items' do
    let :sample_row_xml_electronic do
      Nokogiri::XML('<Row>
        <Column0>0</Column0>
        <Column1>Mathematical Association of America</Column1>
        <Column2>2012-02-25T18:22:24</Column2>
        <Column3>9934375548502952</Column3>
        <Column4>Mathematics--Periodicals.; Electronic journals.</Column4>
        <Column5>Mathematics magazine</Column5>
        <Column6>Taylor &amp; Francis Social Science and Humanities Library</Column6>
        <Column7>01GALI_GSU</Column7>
        <Column8>Georgia State University</Column8>
        <Column9>QA</Column9>
        <Column10>2018-05-14</Column10>
        <Column11>2018-05-14</Column11>
        <Column12>Available</Column12>
        <Column13>Journal</Column13>
      </Row>').xpath('//Row').first
    end
    it 'creates a electronic Title' do
      title = ReportParser.title_from sample_row_xml_electronic, 'electronic'
      expect(title.availability).to eq 'Available'
      expect(title.receiving_date).to eq Date.new(2018, 5, 14)
    end
  end
end