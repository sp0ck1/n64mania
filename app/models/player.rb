class Player < ActiveRecord::Base
    has_many :comments, :class_name => 'Comment'
    has_many :placements, :class_name => 'Placement'
    has_many :races, :class_name => 'Race', through: :placements

    def merge_with(id_of_duplicate_player)
    second_player = Player.find(id_of_duplicate_player)

      Comment.where(player_id: id_of_duplicate_player).each do |comment|
        comment.update(player_id: self.id)
      end

      Placement.where(player_id: id_of_duplicate_player).each do |placement|
        placement.update(player_id: self.id)
      end

      comment_check = Comment.where(player_id: id_of_duplicate_player).empty?
      placement_check = Placement.where(player_id: id_of_duplicate_player).empty?

      if comment_check && placement_check
        second_player.destroy
      end
    end
end

