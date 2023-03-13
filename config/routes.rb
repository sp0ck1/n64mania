Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # method 'views/:etc', to 'controller#method'
  root 'pages#index'
  
  post 'parse_input', to: 'pages#parse_input'
  post 'game-search', to: 'pages#parse_search'
  get 'unplayed/:genre',  to: 'races#search_by_genre' # rename/reroute this endpoint
  get 'games/unplayed', to: 'games#unplayed'
  scope :api do
    get 'games/unplayed',   to: 'games#api_unplayed'
    get 'games/played',     to: 'games#played'
    get 'races/random',     to: 'races#random'
    get 'games/random',     to: 'games#random'
    get 'races/random/url', to: 'races#random_url'
  end
  resources :games
  resources :players
  resources :races
end
