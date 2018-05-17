class DataTablesController < ApplicationController
  def table_view
    @data_titles = Title.all
  end
end
