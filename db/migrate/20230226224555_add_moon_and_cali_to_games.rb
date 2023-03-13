class AddMoonAndCaliToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :has_moon, :boolean
    add_column :games, :has_cali, :boolean
  end
end
