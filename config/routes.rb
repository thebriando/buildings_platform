Rails.application.routes.draw do
  resources :clients do
    resources :buildings, only: [ :create, :update, :index ]
  end

  namespace :external do
    resources :buildings, only: [ :index ]
  end
end
