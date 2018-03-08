# frozen_string_literal: true

class AlmaReportsApi
  include HTTParty
  base_uri 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/'
  API_ENDPOINT = '/analytics/reports'.freeze
  DEFAULT_ROWS = 1000
  attr_accessor :report_xml
  def self.pull(path)
    response = get_report path
    if response.success?
      # start constructing report object
      report = ReportResponse.new(response)
    else
      raise response.response
    end
    complete report
  end

  def self.complete(report)
    return report if report.finished?
    report.append get_report(nil, report.resumption_token)
    report
  end

  def self.get_report(report = nil, token = nil)
    raise(StandardError, 'Cannot get report without report name or token') unless report || token
    query = { limit: DEFAULT_ROWS }
    query[:path] = report if report
    query[:token] = token if token
    get(
      API_ENDPOINT,
      query: query,
      headers: { 'Authorization' => "apikey #{Rails.application.secrets.api_key}" }
    )
  end

end