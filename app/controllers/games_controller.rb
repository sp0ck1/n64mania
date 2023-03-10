class GamesController < ApplicationController

    def index
        @games = Game.all.sort_by { |game| game.name }
    end

    def show
        @game = Game.find(params[:id])
        @raced = Race.where(game_id: @game.id).empty? ? "Not Raced" : "Raced"
        @publisher = @game.publisher
        @developer = @game.developer
        @year = @game.release_year
    end

    def test
        puts "It's real!"
        render json: Game.find(params[:id])
    end

    def api_unplayed
        race_ids = []
        Race.all.each do |race|
            race_ids << race.game_id
        end
    @rgames = Game.where.not(id: race_ids) 
    render json: @rgames
    end

    def random_game_name
      race_ids = []
      Race.all.each do |race|
          race_ids << race.game_id
      end
      random_game = Game.where.not(id: race_ids).sample.name
      render html: random_game
    end
      
    
end
