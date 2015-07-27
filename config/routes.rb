Rails.application.routes.draw do
  root to: "posts#index"
  resources :users, only: [:new, :create]
  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  get "/global" => "posts#index"
  get "/feed"   => "posts#feed"

  get "/login"  => "sessions#new"
  post "/login" => "sessions#create"
  get "/logout" => "sessions#destroy"
  get "/join"   => "users#new"
end
