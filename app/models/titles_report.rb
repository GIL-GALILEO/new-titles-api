# frozen_string_literal: true

# represent alma analytics report
# collates responses across calls and builds titles
class TitlesReport
  attr_accessor :titles, :failed_rows

  def initialize(report)
    @titles = []
    @failed_rows = []
    unfinished = true
    token = nil
    while unfinished
      query = { rows: 1000 }
      query[:path] = report unless token
      query[:token] = token if token
      response = AlmaReportsApi.call query
      raise StandardError('Response not successful') unless response.success?
      xml_doc = parse_xml response
      extract_titles_from xml_doc
      token = token_from xml_doc
      unfinished = !finished_from(xml_doc)
    end
  end

  private

  def token_from(xml_doc)
    xml_doc.xpath('//ResumptionToken').text.to_s
  end

  def finished_from(xml_doc)
    xml_doc.xpath('//IsFinished').text.to_s
  end

  def parse_xml(response)
    xml_doc = Nokogiri::XML(response.body)
    xml_doc.remove_namespaces!
  end

  def extract_titles_from(xml_doc)
    rows = xml_doc.xpath('//Row')
    rows.each do |row|
      begin
        titles << ReportParser.title_from(row)
      rescue StandardError
        failed_rows << row
        next
      end
    end
  end
end