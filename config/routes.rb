# frozen_string_literal: true

Rails.application.routes.draw do
  get 'test', to: 'application#test'
  get 'institutions', to: 'application#institutions'
end
