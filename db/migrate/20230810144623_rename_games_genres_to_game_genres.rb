class RenameGamesGenresToGameGenres < ActiveRecord::Migration[6.0]
  def change
    rename_table 'games_genres', 'game_genres'
  end
end
