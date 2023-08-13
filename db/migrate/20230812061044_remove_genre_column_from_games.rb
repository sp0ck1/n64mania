class RemoveGenreColumnFromGames < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :genre
  end
end
