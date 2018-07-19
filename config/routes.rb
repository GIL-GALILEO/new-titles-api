# frozen_string_literal: true

Rails.application.routes.draw do

  # Table endpoints
  get '(:shortcode)', to: 'table#index', as: 'table_view'

  # API emspoints
  constraints format: :json do
    get 'v1', to: 'titles#index'
  end

  root to: 'table#index'

end
