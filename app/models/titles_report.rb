# frozen_string_literal: true

# represent alma analytics report
# collates responses across calls and builds titles
class TitlesReport
  attr_accessor :titles, :failed_rows, :medium, :calls

  def initialize(report)
    @titles = []
    @failed_rows = []
    @calls = 0
    unfinished = true
    token = nil
    medium = report =~ /Electronic/ ? 'electronic' : 'physical'
    while unfinished
      query = { limit: 500, col_names: false }
      query[:path] = report unless token
      query[:token] = token if token
      response = AlmaReportsApi.call query
      raise(StandardError, "Response not successful [call ##{calls}]: #{response&.message}") unless response&.success?
      @calls += 1
      xml_doc = parse_xml response
      extract_titles_from xml_doc, medium
      token ||= token_from xml_doc
      unfinished = !finished_from(xml_doc)
    end
  end

  private

  def token_from(xml_doc)
    xml_doc.xpath('//ResumptionToken').text.to_s
  end

  def finished_from(xml_doc)
    xml_doc.xpath('//IsFinished').text.to_s == 'true'
  end

  def parse_xml(response)
    xml_doc = Nokogiri::XML(response.body)
    xml_doc.remove_namespaces!
  end

  def extract_titles_from(xml_doc, medium)
    rows = xml_doc.xpath('//Row')
    rows.each do |row|
      begin
        titles << ReportParser.title_from(row, medium)
      rescue StandardError => e
        failed_rows << { row: row, message: e.message }
        next
      end
    end
  end
end