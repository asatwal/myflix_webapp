require 'sidekiq/web'

Myflix::Application.routes.draw do

  root to: 'videos#index'

  resources :videos, only: [:index, :show] do

    collection do
      get :search
    end

    member do
      post :review
    end
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :users, only: [:new, :create, :show]

  get 'users/new_invited/:token', to: 'users#new_invited', as: 'new_invited_user'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'front', to: 'pages#front'
  get 'confirm_password_reset', to: 'pages#confirm_password_reset'
  get 'invalid_token', to: 'pages#invalid_token'

  get 'videos/category/:id', to: 'videos#category', as: :category

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :queue_items, only: [:create, :destroy]

  get 'ui(/:action)', controller: 'ui'

  get 'people', to: 'relationships#index'

  resources :relationships, only: [:create, :destroy]

  # Must pluralise otherwise get _index in the path

  resources :forgot_passwords, only: [:new, :create]

  resources :reset_passwords, only: [:show, :create]

  resources :invitations, only: [:new, :create]

  mount Sidekiq::Web, at: '/sidekiq'

end
