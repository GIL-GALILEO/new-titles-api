# frozen_string_literal: true

# Wrapper for Analytics API report call
class AlmaReportsApi
  include HTTParty
  BASE_URI = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/'
  API_ENDPOINT = '/analytics/reports'
  MAX_RETRIES = 3

  base_uri BASE_URI

  # Makes a call to the Alma Reports API and returns a response for the given query
  # @param [Query] query
  # @param [Institution] institution
  # @param [Slack::Notifier] notifier
  # @return [HTTParty::Response]
  def self.call(query, institution, notifier: Slack::Notifier.new(Rails.application.secrets.slack_worker_webhook))
    tries ||= MAX_RETRIES
    api_key = Rails.application.secrets.send("#{institution.shortcode}_api_key")
    response = get(
      API_ENDPOINT,
      query: query,
      headers: { 'Authorization' => "apikey #{api_key}" }
    )

    if response&.success? == false
      notifier.ping(error_message(response, institution.shortcode, query))
    end

    response

  rescue Net::OpenTimeout
    if (tries - 1).positive?
      tries -= 1
      retry
    else
      notifier.ping "MAX_RETRIES exhausted: #{MAX_RETRIES}"
    end
  end

  def self.error_message(response, institution_name, query)

    message = <<~HEREDOC
      Report pull fail.
      status: #{response.code}.
      Institution: #{institution_name}.
      Query: #{query}.
    HEREDOC
    errors = parse_error(response.body)
    unless errors.empty?
      message += "API Response:\n"
      errors.each do |error|
        message += "#{error.code}. #{error.message} tracking: #{error.tracking_id}\n"
        message += '-' * 10
      end
      message
    end

  end

  def self.parse_error(body)
    xml_doc = Nokogiri::XML(body).remove_namespaces!
    parsed = []
    if xml_doc&.xpath('//errorsExist')&.text.to_s == 'true'
      errors = xml_doc.css('errorList error')
      errors.each do |error|
        row = OpenStruct.new
        row.code = error.css('errorCode').text
        row.message = error.css('errorMessage').text
        row.tracking_id = error.css('trackingId').text
        parsed << row
      end
    end
    parsed
  end

end