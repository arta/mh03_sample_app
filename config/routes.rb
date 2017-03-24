Rails.application.routes.draw do
  resources :users do
    get :followees, on: :member, path: :following #=> get `/users/1/following`
    get :followers, on: :member
  end
  resources :account_activations, only: :edit
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :followships,         only: [:create, :destroy]

  get    '/signup',  to: 'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'

  root 'static_pages#home'
end
