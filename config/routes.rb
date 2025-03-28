Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end
  
  get "cart/show"
  resources :categories
  resources :products
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post '/cart/add/:id', to: 'cart#add', as: 'add_to_cart'
  patch '/cart/update/:id', to: 'cart#update', as: 'update_cart_item'
  delete '/cart/remove/:id', to: 'cart#remove', as: 'remove_cart_item'
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root 'products#index'
end
