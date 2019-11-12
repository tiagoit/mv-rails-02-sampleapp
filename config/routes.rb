Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  # Static pages
  get  '/help', to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  # Session
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # Users
  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users

  # Account activation
  resources :account_activations, only: %i[edit]

  # Password reset
  resources :password_resets, only: %i[new create edit update]
end
