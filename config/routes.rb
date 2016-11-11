Rails.application.routes.draw do
  get 'people/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index', to: 'application#index', as: :index
  get '/people/members', to: 'members#index'
  get '/people/members/current', to: 'members#current'

  resources :people, only: [:index, :show]

  resources :contact_points, only: [:index, :show]

  resources :parties, only: [:index, :show]
end
