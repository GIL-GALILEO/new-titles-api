# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sample_view', to: 'data_tables#table_view'

  constraints format: :json do
    get 'new_titles', to: 'titles#index'
  end

end
