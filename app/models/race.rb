class Race < ActiveRecord::Base

    has_many :comments, :class_name => 'Comment', dependent: :destroy
    has_many :placements, :class_name => 'Placement', dependent: :destroy
    belongs_to :game, :class_name => 'Game', :foreign_key => :game_id
    has_many :players, :class_name => 'Player', through: :placements

  def winner
    return Player.find(self.placements.find_by_placement(1).player_id)
  end

  # Check if there is a race of this game with a date less than this race's date
  def runback?
    race_date = Race.arel_table[:date]
    Race.where(game_id: self.game_id).where(race_date.lt(self.date)).exists?
  end

end