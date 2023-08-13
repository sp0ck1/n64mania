class Game < ActiveRecord::Base

    has_many :races, :class_name => 'Race'

    has_many :game_genres
    has_many :genres, through: :game_genres

    def self.unplayed
        race_ids = []
        Race.all.each do |race|
            race_ids << race.game_id
        end
    @rgames = Game.where.not(id: race_ids) 
    end

    def pipe_split_genres
      a = []
      self.genres.each do |g|
        a << g.name
      end
      a.join(" | ")
    end

    def pipe_split_genres_as_links
      # Write code in view first, then transfer here.
    end

    def start_race_full(game_name, goal)
      
      # Ensure rtgg access token is set. Already done on server init unless local dev
      RacetimeManager::StartClient.call if ENV["rtgg_token"].nil?
      link = RacetimeManager::StartRace.call(game_name, goal)
    end

    def start_race_with_goal(goal)
      start_race_full(self.name, goal)
    end

    def start_race
      goal = Race.where(game_id: self.id).last
      start_race_full(self.name, goal)
    end
    
    def raced?
      Race.where(game_id: self.id).present?
    end

end
