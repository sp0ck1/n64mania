class AddIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :races, :game_id
    add_index :game_genres, [:game_id, :genre_id]
  end
end
