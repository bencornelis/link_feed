Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  root to: "posts#index"

  resources :users do
    resources :follows, only: [:create, :destroy]
    resources :followers, only: [:index]
    resources :followees, only: [:index]
  end

  resource :profile, only: [:show]

  namespace :posts do
    resource :feed, only: [:show]
  end

  resources :posts do
    resources :shares, only: [:create]
    resources :comments, except: [:index]
    resources :badgings, only: [:create]
    resources :sharers, only: [:index]

    member do
      get 'preview'
    end
  end

  namespace :comments do
    resource :feed, only: [:show]
  end

  resources :comments, only: [:index] do
    resources :shares, only: [:create]
    resources :badgings, only: [:create]
    resources :sharers, only: [:index]
  end

  resources :tags, only: [:index]

  devise_scope :user do
    get '/login',  to: 'devise/sessions#new'
    post '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
    get '/join',   to: 'devise/registrations#new'
  end

  get "/global"  => "posts#index"

  # static pages
  get "/about"   => "pages#about"
  get "/faq"     => "pages#faq"
end
