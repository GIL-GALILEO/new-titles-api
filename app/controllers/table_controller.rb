class TableController < ApplicationController
  def index

    @institutions = Institution.all
    @institution = Institution.find_by_shortcode(params[:shortcode])

    respond_to do |format|
      format.html
      format.json { render json: TitlesDatatable.new(view_context, @institution) }
    end
  end
end
