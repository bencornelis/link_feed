Rails.application.routes.draw do
  root to: "home#index"
  resources :users, only: [:new, :create]

  get "/login"  => "sessions#new"
  post "/login" => "sessions#create"
  get "/logout" => "sessions#destroy"
end
