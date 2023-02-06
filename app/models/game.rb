class Game < ActiveRecord::Base

    has_many :races, :class_name => 'Race'

    def self.retrieve_comments
    # Get the comments for a game from URL
    end

    def self.unplayed
        race_ids = []
        Race.all.each do |race|
            race_ids << race.game_id
        end
    @rgames = Game.where.not(id: race_ids) 
    end

end
