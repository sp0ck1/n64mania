class Comment < ActiveRecord::Base

    belongs_to :player, :class_name => 'Player', :foreign_key => :player_id
    belongs_to :race, :class_name => 'Race', :foreign_key => :race_id
    
end
