Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks, only: %i[index new create] do
    put 'completed', on: :member
    post 'reassign_task', on: :collection
  end

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get '/auth/:provider/callback', to: 'sessions#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
