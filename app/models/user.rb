class User < ActiveRecord::Base
  validates :twitch_nickname, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: true

end