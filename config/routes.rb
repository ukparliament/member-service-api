Rails.application.routes.draw do
  get 'people/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index', to: 'application#index', as: :index
  get '/people/members', to: 'members#index'
  get '/people/members/current', to: 'members#current'

  resources :people, only: [:index, :show] do
    get '/constituencies', to: 'constituencies#people'
    get '/constituencies/current', to: 'current_constituencies#people'
  end

  resources :contact_points, only: [:index, :show]

  resources :constituencies, only: [:index, :show] do
    get '/members', to: 'constituencies#members'
    get '/members/current', to: 'constituencies#current_members'
  end
end
