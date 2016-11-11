Rails.application.routes.draw do
  get 'people/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index', to: 'application#index', as: :index

  resources :people, only: [:index, :show] do
    get '/constituencies', to: 'people#constituencies'
    get '/constituencies/current', to: 'people#current_constituencies'
  end

  get '/people/members', to: 'members#index'
  get '/people/members/current', to: 'members#current'

  resources :contact_points, only: [:index, :show]

  resources :parties, only: [:index, :show] do
    get 'members', to: 'parties#all_members'
    get 'members/current', to: 'parties#all_current_members'
  end

  get '/parties/current', to: 'parties#current'

  resources :constituencies, only: [:index, :show] do
    get '/members', to: 'constituencies#members'
    get '/members/current', to: 'constituencies#current_members'
  end

  get '/constituencies/current', to: 'constituencies#current'

end
