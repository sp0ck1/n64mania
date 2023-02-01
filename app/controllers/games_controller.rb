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

    def unplayed
        race_ids = []
        Race.all.each do |race|
            race_ids << race.game_id
        end
    @rgames = Game.where.not(id: race_ids) 
    end
end
