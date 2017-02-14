Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index', to: 'application#index', as: :index

  match 'people/:letter', to: 'people#letters', letter: /[a-z]/, via: [:get]
  get 'people/by', to: 'people#by_identifier'

  get '/people/members', to: 'members#index'
  get '/people/members/current', to: 'members#current'
  match '/people/members/:letter', to: 'members#letters', letter: /[A-Za-z]/, via: [:get]
  match '/people/members/current/:letter', to: 'members#current_letters', letter: /[A-Za-z]/, via: [:get]

  get '/constituencies/by', to: 'constituencies#by_identifier'
  get '/constituencies/current', to: 'constituencies#current'
  match '/constituencies/:letter', to: 'constituencies#letters', letter: /[A-Za-z]/, via: [:get]
  match '/constituencies/current/:letter', to: 'constituencies#current_letters', letter: /[A-Za-z]/, via: [:get]

  get '/parties/by', to: 'parties#by_identifier'
  get '/parties/current', to: 'parties#current'
  match 'parties/:letter', to: 'parties#letters', letter: /[A-Za-z]/, via: [:get]

  get '/houses/by', to: 'houses#by_identifier'

  get '/contact_points/by', to: 'contact_points#by_identifier'

  resources :people, only: [:index, :show] do
    get '/constituencies', to: 'people#constituencies'
    get '/constituencies/current', to: 'people#current_constituency'
    get '/parties', to: 'people#parties'
    get '/parties/current', to: 'people#current_party'
    get '/contact_points',to: 'people#contact_points'
    get '/houses',to: 'people#houses'
    get '/houses/current', to: 'people#current_house'
    get '/sittings', to: 'people#sittings'
  end

  resources :contact_points, only: [:index, :show]

  resources :parties, only: [:index, :show] do
    get '/members', to: 'parties#members'
    get '/members/current', to: 'parties#current_members'
    match '/members/:letter', to: 'parties#members_letters', letter: /[A-Za-z]/, via: [:get]
    match '/members/current/:letter', to: 'parties#current_members_letters', letter: /[A-Za-z]/, via: [:get]
  end

  resources :constituencies, only: [:index, :show] do
    get '/members', to: 'constituencies#members'
    get '/members/current', to: 'constituencies#current_member'
    get '/contact_point', to: 'constituencies#contact_point'
  end

  resources :houses, only: [:index, :show] do
    get '/members', to: 'houses#members'
    get '/members/current', to: 'houses#current_members'
    get '/parties', to: 'houses#parties'
    get '/parties/:party_id', to: 'houses#party'
    get '/parties/current', to: 'houses#current_parties'
    match '/members/:letter', to: 'houses#members_letters', letter: /[A-Za-z]/, via: [:get]
    match '/members/current/:letter', to: 'houses#current_members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/parties/:party_id/members', to: 'houses#party_members'
    match '/parties/:party_id/members/:letter', to: 'houses#party_members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/parties/:party_id/members/current', to: 'houses#current_party_members'
    match '/parties/:party_id/members/current/:letter', to: 'houses#current_party_members_letters', letter: /[A-Za-z]/, via: [:get]
  end

end
