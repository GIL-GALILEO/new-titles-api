# frozen_string_literal: true

# Controller for handling API requests and returning title
class TitlesController < ApplicationController
  before_action :authenticate_and_set_inst
  rescue_from(ActiveRecord::RecordNotFound) { head :not_found }
  def index
    @titles = Title.includes(:institution)
                   .order(:receiving_date)
                   .where(institution: @institution)
                   .page(params[:page])
    # filter by media type
    if params[:media_type]
      media_types = media_types_map[params[:media_type].downcase.to_sym]
      @titles = @titles.where(material_type: media_types) if media_types&.any?
    end
    @titles = @titles.where(location: params[:location]) if params[:location]
    render json: @titles.to_json(
      except: %i[id created_at updated_at institution_id],
      methods: :inst_name
    )
  end

  private

  def authenticate_and_set_inst
    token = request.headers['X-User-Token']
    @institution = Institution.find_by_api_key token
    if @institution
      true
    else
      head :unauthorized
    end
  end

  # move to YAML file and load only when param is found
  def media_types_map
    {
      dvd: ['Blu-Ray', 'Blu-Ray and DVD', 'DVD', 'DVD-ROM'],
      music: ['Sound Recording', 'Audio cassette', 'LP', 'Phonograph Record'],
      book: ['Book'],
      map: ['Map', 'Atlas'],
      device: ['Tablet', 'Calculator', 'Camcorder', 'Tablet', 'iPad', 'Laptop'],
      unknown: ['Unknown'],
      none: ['None'],
      thesis: ['Thesis', 'Master Thesis', 'Dissertation', 'PhD Thesis']
    }
  end

end
