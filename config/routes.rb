Rails.application.routes.draw do
  root to: 'products#index'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/pages/:slug', to: 'pages#show', as: :page
  
  get 'cart/show', to: 'cart#show'
  post '/cart/add/:id', to: 'cart#add', as: 'add_to_cart'
  patch "/cart/update/:id", to: 'cart#update', as: 'update_cart_item'
  delete '/cart/remove/:id', to: 'cart#remove', as: 'remove_cart_item'
  
  get '/search', to: 'search#index', as: 'search'
  
  post '/orders/:id/payments', to: 'payments#create', as: 'create_payment'
  get '/orders/:order_id/payments/success', to: 'payments#success', as: 'success_payment'
  
  resources :categories
  resources :products
  resources :customers, except: [:index, :destroy]
  resources :addresses
  resources :orders, only: [:index, :show, :new, :create] do
    collection do
      post 'review'
    end
  end
  
  devise_for :users
  
  get 'up', to: 'rails/health#show', as: :rails_health_check
end