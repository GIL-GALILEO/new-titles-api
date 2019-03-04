# frozen_string_literal: true

# Wrapper for Analytics API report call
class AlmaReportsApi
  include HTTParty
  BASE_URI = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/'
  API_ENDPOINT = '/analytics/reports'
  MAX_RETRIES = 3

  base_uri BASE_URI


  def self.call(query, institution)
    tries ||= MAX_RETRIES
    api_key = Rails.application.secrets.send("#{institution.shortcode}_api_key")
    response = get(
      API_ENDPOINT,
      query: query,
      headers: { 'Authorization' => "apikey #{api_key}" }
    )
    response
  rescue Net::OpenTimeout
    if (tries - 1).positive?
      tries -= 1

      retry
    else
      # Slack.error "Report pull failed! ```#{e}```"
      raise StandardError, "MAX_RETRIES exhausted: #{MAX_RETRIES}"
    end
  # rescue StandardError
  #   # Slack.error "Report pull failed mysteriously! ```#{e}```"
  #   nil
  end

end