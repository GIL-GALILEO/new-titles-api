class DataTablesController < ApplicationController
  def table_view
    respond_to do |format|
      format.html
      format.json {render json: TitlesDatatable.new(view_context) }
    end
  end
end
