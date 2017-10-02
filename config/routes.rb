Rails.application.routes.draw do
  root to: "posts#index"

  resources :users do
    resources :follows, only: [:create, :destroy]
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

  get "/global"  => "posts#index"
  get "/login"   => "sessions#new"
  post "/login"  => "sessions#create"
  get "/logout"  => "sessions#destroy"
  get "/join"    => "users#new"

  # static pages
  get "/about"   => "pages#about"
  get "/faq"     => "pages#faq"
end
