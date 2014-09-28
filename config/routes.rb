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

  resources :users, only: [:new, :create]

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'front', to: 'pages#front'

  get 'videos/category/:id', to: 'videos#category', as: :category

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :queue_items, only: [:create, :destroy]

  get 'ui(/:action)', controller: 'ui'

end
