class Race < ActiveRecord::Base

    has_many :comments, :class_name => 'Comment', dependent: :destroy
    has_many :placements, :class_name => 'Placement', dependent: :destroy
    belongs_to :game, :class_name => 'Game', :foreign_key => :game_id




end
