require 'resque/server'


Rails.application.routes.draw do
  resources :uploads, only: [:new, :create]
  resources :skus, only: [:index]
  resources :suppliers, only: [:index]

  mount Resque::Server.new, :at => "/resque"

  root to: 'uploads#new'
end
