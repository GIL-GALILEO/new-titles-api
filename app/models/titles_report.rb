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
                          report_type: @report_type,
                          path: report_path)
    @xml_doc = nil
  end

  def create
    until finished? @xml_doc
      @calls += 1
      check_for_token @xml_doc
      response = @api.call(@query, @institution)
      raise(StandardError, error_message(response)) unless response&.success?

      @xml_doc = parse_xml response
      extract_titles_from @xml_doc, @type
    end
    self
  end

  private

  def check_for_token(xml_doc)
    token = xml_doc&.xpath('//ResumptionToken')&.text.to_s
    @query[:token] = token unless token.blank?
    if @calls > 1 && !@query.key?(:token)
      raise StandardError, "Resumption Token not set for call ##{@calls} to API. Query: #{@query}, XML: #{@xml_doc}"
    end
  end

  def finished?(xml_doc)
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
      Response not successful [call ##{@calls}]: #{response&.body}
      Institution: #{@institution.name}.
      Report Type: #{@report_type}.
    HEREDOC
    message
  end

  def report_path
    path = if @report_type.downcase == 'physical'
             @institution.physical_path
           else
             @institution.electronic_path
           end
    path
  end
end