class Player < ActiveRecord::Base



    has_many :comments, :class_name => 'Comment'
    has_many :placements, :class_name => 'Placement'
end
