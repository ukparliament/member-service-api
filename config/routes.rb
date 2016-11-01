Rails.application.routes.draw do
  get 'people/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index', to: 'application#index', as: :index

  resources :people, only: [:index, :show]
end
