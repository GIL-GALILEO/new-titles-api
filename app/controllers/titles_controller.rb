# frozen_string_literal: true

# Controller for handling API requests and returning title
class TitlesController < ApplicationController
  def index
    date = date_from_days
    @titles = Title.where('receiving_date >= ?', date)
    @titles.where(institution: institution) unless institution.code == '01GALI_NETWORK'
    # @titles.where(material_type: params['type']) if params['type']
    # probably want to limit the number fo returned items? pagination?
    render json: @titles
  end

  private

  def institution
    # get inst from API key used in request
    Institution.find 1 # Use USG for now
  end

  def date_from_days
    days = params[:days] || 30
    Date.today - days
  end
end
