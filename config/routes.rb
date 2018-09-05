# frozen_string_literal: true

Rails.application.routes.draw do

  # Table endpoints
  get '(:shortcode)', to: 'table#index', as: 'table_view'

  # API endpoints
  scope :api do
    constraints format: :json do
      scope :v1 do
        get 'list', to: 'titles#index'
      end
    end
  end


  root to: 'table#index'

end
