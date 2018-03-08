# frozen_string_literal: true

# represent alma analytics report response
class ReportResponse
  attr_accessor :rows, :resumption_token, :finished
  def initialize(response)
    xml_doc = parsed_xml response
    self.finished = finished_from xml_doc
    self.resumption_token = token_from xml_doc
    self.rows = xml_doc.xpath('//Row')
  end

  def append(response)
    self.rows = rows + parsed_xml(response).xpath('//Row')
  end

  def finished?
    finished == 'true'
  end

  private

  def token_from(xml_doc)
    xml_doc.xpath('//ResumptionToken').text.to_s
  end

  def finished_from(xml_doc)
    xml_doc.xpath('//IsFinished').text.to_s
  end

  def parsed_xml(response)
    xml_doc = Nokogiri::XML(response.body)
    xml_doc.remove_namespaces!
  end
end