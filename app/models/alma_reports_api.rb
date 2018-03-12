# frozen_string_literal: true

# Wrapper for Analytics API report call
class AlmaReportsApi
  include HTTParty
  base_uri 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/'
  API_ENDPOINT = '/analytics/reports'.freeze

  def self.call(query)
    response = get(
      API_ENDPOINT,
      query: query,
      headers: { 'Authorization' => "apikey #{Rails.application.secrets.api_key}" }
    )
    tries ||= 3
    response
  rescue ResponseError
    if (tries -= 1) > 0
      retry
    else
      # Slack.error "Report pull failed! ```#{e}```"
      nil
    end
  rescue StandardError
    # Slack.error "Report pull failed mysteriously! ```#{e}```"
    nil
  end
end