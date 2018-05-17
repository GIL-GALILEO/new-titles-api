# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sample_view', to: 'data_tables#table_view'

  constraints format: :json do
    get 'test', to: 'application#test'
    get 'institutions', to: 'application#institutions'
    get 'new_titles/:days/:media', to: 'titles#index'
    get 'new_titles/:days', to: 'titles#index'
    get 'new_titles', to: 'titles#index'
  end

end
