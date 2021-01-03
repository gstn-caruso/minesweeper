# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'application#index'

  get '/games/:id', to: 'games#show'
end
