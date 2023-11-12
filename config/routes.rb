Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # method 'views/:etc', to 'controller#method'
  root 'pages#index'
  
  # Search box endpoints
  post 'parse_input', to: 'pages#parse_input'
  post 'game-search', to: 'pages#parse_search'

  get 'unplayed/:genre',  to: 'races#search_by_genre' # rename/reroute this endpoint
  get 'games/unplayed', to: 'games#unplayed'
  get 'games/grid', to: 'games#grid'
  post 'start_race', to: 'games#start_race'

  # Login/Logout endpoints
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'

  # JenniferHawk API call endpoints
  scope :api do
    get 'games/unplayed/random',   to: 'games#random_game_name'
    get 'games/unplayed',          to: 'games#api_unplayed'
    get 'games/played',            to: 'games#played'
    get 'games/random',            to: 'games#random'
    get 'races/random',            to: 'races#random'
    get 'races/random/url',        to: 'races#random_url'
    get 'races/runback',           to: 'races#runback'
    get 'commands/:command',       to: 'commands#serve'
  end

  get 'portal', to: 'portal#index'



  resources :games
  resources :players
  resources :races

  resources :users, except: [:new]
  resources :genres, except: [:edit, :new, :update]
  resources :commands
  
end
