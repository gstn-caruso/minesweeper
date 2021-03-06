# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api/docs'
  mount Rswag::Api::Engine => '/api/docs'

  root to: 'application#index'
  get '/:game_id', to: 'application#index'

  namespace :api do
    get '/games/:id', to: 'games#show'
    post '/games', to: 'games#create'
    post '/games/:id/reveal', to: 'games#reveal'
    post '/games/:id/flag', to: 'games#flag'
  end
end
