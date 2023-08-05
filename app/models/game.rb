class Game < ActiveRecord::Base

    has_many :races, :class_name => 'Race'

    def self.unplayed
        race_ids = []
        Race.all.each do |race|
            race_ids << race.game_id
        end
    @rgames = Game.where.not(id: race_ids) 
    end

    def start_race(name, goal)
      
      # Ensure rtgg access token is set. Already done on server init unless local dev
      RacetimeManager::StartClient.call if Rails.env.development?
      link = RacetimeManager::StartRace.call(name, goal)
    end

    def start_race(goal)
      
      # Ensure rtgg access token is set. Already done on server init unless local dev
      RacetimeManager::StartClient.call if Rails.env.development?
      link = RacetimeManager::StartRace.call(self.name, goal)
    end

end
