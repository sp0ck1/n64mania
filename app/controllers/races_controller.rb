class RacesController < ApplicationController

    def index
        @races = Race.all
    end

    def search_by_genre
      racing_games = {}
      race_game_ids = []
      Race.all.each do |race|
        race_game_ids << race.game_id
      end
      Game.all.each do |game|
        if game.genre.downcase.include? params[:genre]  
          unless race_game_ids.include? game.id   
            racing_games[game.id] = game.name      
          end  
        end  
      end
      render :json => racing_games
    end
end
