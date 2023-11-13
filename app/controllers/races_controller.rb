class RacesController < ApplicationController

    def index
      @page_title = "All N64Mania Races | N64Mania"
      @page_description = "All N64Mania races, including runbacks."
     
    end

    def show

      @race = Race.find(params[:id])
      race_name = @race.game.name
      @page_title = "#{race_name} | N64Mania"
      @page_description = "#{race_name}'s N64Mania race page."
      
    end

    def search_by_genre
      racing_games = {}
      race_game_ids = []
      Race.all.each do |race|
        race_game_ids << race.game_id
      end
      Game.all.each do |game|
        if game.pipe_split_genres.downcase.include? params[:genre]  
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
      
      game_name = Game.find(race.game_id).name
      winner_name = Player.find(winner_placement.player_id).name
      comment = race.comments.sample
      comment_text = comment.comment_text
      commenter = Player.find_by_id(comment.player_id).name
      
      runback = {
        :game      => game_name,
        :winner    => winner_name,
        :comment   => comment_text,
        :commenter => commenter
      }
      render :json => runback
    end
end
