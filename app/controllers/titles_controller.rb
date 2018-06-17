# frozen_string_literal: true

# Controller for handling API requests and returning title
class TitlesController < ApplicationController

  def index
    @titles = Title.includes(:institution)
                   .order(:receiving_date)
                   .page(params[:page])

    # filter by media type
    if params[:media_type]
      media_types = media_types_map[params[:media_type].to_sym]
      @titles = @titles.where(material_type: media_types) if media_types.any?
    end

    render json: @titles.to_json(
      except: %i[id created_at updated_at institution_id],
      methods: :inst_name
    )
  end

  private

  def institution
    # get inst from API key used in request
    Institution.find 1 # Use USG for now
  end

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
