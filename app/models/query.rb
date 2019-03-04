# frozen_string_literal: true

# Represents a query used to request an alma analytics report
class Query
  # Creates a query hash used to receive an alma analytics report.
  # If token is provided creates a token key/value pair, otherwise
  # it creates a path key/value pair using institution name and report type
  # @param [String] institution_name
  # @param [String] report_type
  # @param [String] token
  def self.create(institution_name: nil, report_type: nil, token: nil)
    query = { limit: 500, col_names: false }
    if !token.blank?
      query[:token] = token
    elsif institution_name.blank?
      raise ArgumentError, "institution_name can't be blank when token is blank"
    elsif report_type.blank?
      raise ArgumentError, "report_type can't be blank when token is blank"
    else
      query[:path] = "/shared/#{institution_name}/Reports/#{report_type}"
    end
    query
  end
end