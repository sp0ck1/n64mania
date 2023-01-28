Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # method 'views/:etc', to 'controller#method'
  root 'pages#index'
  
  post 'parse_input', to: 'pages#parse_input'
  post 'game-search', to: 'pages#parse_search'
  get 'unplayed/:genre',  to: 'races#search_by_genre'
  resources :games
  resources :players
  resources :races
end
