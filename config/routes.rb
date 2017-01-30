Rails.application.routes.draw do
  get '/helf', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  root 'static_pages#home'
end
