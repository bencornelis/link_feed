Rails.application.routes.draw do
  root to: "posts#index"

  resources :users do
    resources :follows
  end

  resources :posts do
    resources :shares
    resources :comments, except: [:index]
  end

  resources :comments, only: [:index]
  resources :tags

  get "/global" => "posts#index"
  get "/recent" => "posts#recent"

  get "/feed"          => "feed#index"
  get "/feed/recent"   => "feed#recent"
  get "/feed/comments" => "feed#comments"

  get "/login"   => "sessions#new"
  post "/login"  => "sessions#create"
  get "/logout"  => "sessions#destroy"
  get "/join"    => "users#new"
  get "/profile" => "users#show"
end
