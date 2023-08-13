class LinkGamesTableToGenresTable < ActiveRecord::Migration[6.0]
  def change
    Game.all.each do |game|
      
      genres_array = game.genre.split("|").each { |g| g.strip! }
      genres_array.each do |loop_genre|
        genre = Genre.find_by_name(loop_genre)
        GameGenre.create(game_id: game.id, genre_id: genre.id)
      end
      end
  end
end
