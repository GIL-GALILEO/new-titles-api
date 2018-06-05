# frozen_string_literal: true

# Controller for handling API requests and returning title
class TitlesController < ApplicationController

  def index
    @titles = Title.includes(:institution)
                   .order(:receiving_date)
                   .page(params[:page])

    # filter by media type
    media_types = media_types_map[params[:media_type].to_sym]
    @titles = @titles.where(material_type: media_types) if media_types.any?

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
      music: ['Sound Recording', 'Audio cassette']
    }
  end

end
