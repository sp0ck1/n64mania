class RacesController < ApplicationController

    def index
        @races = Race.all.sort_by { |race| race.date }
    end

    def show
      @race = Race.find(params[:id])
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

    def random
      render :json => Race.all.sample
    end
    
    def random_url
      render :html => Race.all.sample.url
    end

    def runback
      race = Race.all.sample
      winner_placement = Placement.where(race_id: race.id, placement: 1).first 
      winner_name = Player.find(winner_placement.player_id).name

      game_name = Game.find(race.game_id).name
      comment = race.comments.sample
      commenter = Player.find_by_id(comment.player_id).name
      comment_text = comment.comment_text

      runback = {}
      runback[:game] = game_name
      runback[:winner] = winner_name
      runback[:comment] = comment_text
      runback[:commenter] = commenter

      render :json => runback
    end
end
