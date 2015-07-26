Rails.application.routes.draw do
  root to: "posts#index"
  resources :users, only: [:new, :create]
  resources :posts, except: [:index]

  get "/global" => "posts#index"
  get "/feed"   => "posts#feed"

  get "/login"  => "sessions#new"
  post "/login" => "sessions#create"
  get "/logout" => "sessions#destroy"
end
