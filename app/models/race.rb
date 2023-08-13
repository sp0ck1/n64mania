class Race < ActiveRecord::Base

    has_many :comments, :class_name => 'Comment', dependent: :destroy
    has_many :placements, :class_name => 'Placement', dependent: :destroy
    belongs_to :game, :class_name => 'Game', :foreign_key => :game_id
    has_many :players, :class_name => 'Player', through: :placements

  def winner
    return Player.find(self.placements.find_by_placement(1).player_id)
  end

end