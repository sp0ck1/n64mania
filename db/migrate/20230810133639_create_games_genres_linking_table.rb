class CreateGamesGenresLinkingTable < ActiveRecord::Migration[6.0]
  def change
    create_table :games_genres, id: false do |t|
      t.belongs_to :game
      t.belongs_to :genre
    end
  end
end
