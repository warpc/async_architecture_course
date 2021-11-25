Rails.application.routes.draw do
  root 'transactions#index'

  resources :transactions, only: %i[index show]
  resources :billing_cycles, only: %i[index]

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get '/auth/:provider/callback', to: 'sessions#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
