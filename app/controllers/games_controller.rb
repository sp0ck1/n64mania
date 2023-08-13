class GamesController < ApplicationController

  # select distinct unnest(string_to_array(genre, ' | ')) as c from games order by c;
  # ActiveRecord::Base.connection.execute("select distinct unnest(string_to_array(genre, ' | ')) as c from games order by c;")
  # Get list of distinct genres



    def index
        @games = Game.all.sort_by { |game| game.name }
        @page_title = "All Games | N64Mania"
    end

    def show
        params
        @game = Game.find(params[:id])
        @races = Race.where(game_id: @game.id)
        @raced = @races.empty? ? "Not Raced" : "Raced"
        @publisher = @game.publisher
        @developer = @game.developer
        @year = @game.release_year

        @page_title = "#{@game.name} | N64Mania"
        @page_description = "#{@game.name} game page for N64Mania."

    end

    def unplayed
      @page_title = "All Unplayed Games | N64Mania"
    end
    
    def api_unplayed # Include year in this json
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
      
    def start_race

      goal = params[:goal]
      game_id = params[:game_id]
      redirect_to Game.find(game_id).start_race_with_goal(goal)
    end

    
    
end