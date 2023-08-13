class GenreFromListToTable < ActiveRecord::Migration[6.0]
  def change
    
    # Add uniqueness constraint to genres by name
    execute <<-SQL
      alter table genres
        add constraint name_uniqueness unique (name);
      SQL

    Game.all.each do |game|
      
      genres_array = game.genre.split("|").each { |g| g.strip! }
      genres_array.each do |genre|
        Genre.create(name: genre) unless Genre.find_by_name(genre)
      end

  end


end
end
