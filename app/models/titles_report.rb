# frozen_string_literal: true

# represent alma analytics report
# collates responses across calls and builds titles
class TitlesReport
  attr_accessor :institution, :titles, :failed_rows, :medium, :calls,
                :report_type

  # @param [Institution] institution
  # @param [String] type
  # @param [String] report_override
  # @param [AlmaReportsApi] api
  def initialize(institution, type: 'Physical', report_override: nil, api: AlmaReportsApi)
    @titles = []
    @failed_rows = []
    @calls = 0
    @institution = institution
    @api = api
    @report_type = report_override ? report_override : "New Titles #{type.capitalize}"
    @type = type.downcase
    @query = Query.create(institution_name: institution.name,
                          report_type: @report_type)
  end

  def create
    xml_doc = nil
    until finished_from xml_doc
      @calls += 1
      if @calls > 1 && !@query.key?(:token)
        raise StandardError, "Resumption Token not set for call ##{@calls} to API. Query: #{@query}"
      end
      response = @api.call @query, @institution
      raise(StandardError, error_message(response)) unless response&.success?
      xml_doc = parse_xml response
      extract_titles_from xml_doc, @type
      set_query_token(xml_doc)
    end
    self
  end

  private

  def set_query_token(xml_doc)
    token = xml_doc&.xpath('//ResumptionToken')&.text.to_s
    @query[:token] = token unless token.blank?
  end

  def finished_from(xml_doc)
    xml_doc&.xpath('//IsFinished')&.text.to_s == 'true'
  end

  def parse_xml(response)
    xml_doc = Nokogiri::XML(response.body)
    xml_doc.remove_namespaces!
  end

  def extract_titles_from(xml_doc, medium)
    rows = xml_doc.xpath('//Row')
    rows.each do |row|
      begin
        titles << ReportParser.title_from(@institution, row, medium)
      rescue StandardError => e
        failed_rows << { row: row, message: e.message }
        next
      end
    end
  end

  def error_message(response)
    message = <<~HEREDOC
      Response not successful [call ##{@calls}]: #{response&.message}
      Institution: #{@institution.name}.
      Report Type: #{@report_type}.
    HEREDOC
    message
  end
end