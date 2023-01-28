class Game < ActiveRecord::Base

    has_many :races, :class_name => 'Race'

    def retrieve_comments
    # Get the comments for a game from URL
    end

end
