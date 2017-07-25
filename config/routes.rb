Rails.application.routes.draw do
  root to: "posts#index"

  resources :users do
    resources :follows, only: [:create]
  end

  resource :profile, only: [:show]

  namespace :posts do
    resource :feed, only: [:show]
  end

  resources :posts do
    resources :shares, only: [:create]
    resources :comments, except: [:index]
  end

  namespace :comments do
    resource :feed, only: [:show]
  end
  
  resources :comments, only: [:index]

  resources :tags, only: [:index]

  get "/global" => "posts#index"
  get "/recent" => "posts#recent"

  get "/login"   => "sessions#new"
  post "/login"  => "sessions#create"
  get "/logout"  => "sessions#destroy"
  get "/join"    => "users#new"
end
