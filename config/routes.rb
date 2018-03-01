# frozen_string_literal: true

Rails.application.routes.draw do
  constraints format: :json do
    get 'test', to: 'application#test'
    get 'institutions', to: 'application#institutions'
    get 'new_titles/:date/:type', to: 'titles#index'
  end
end
