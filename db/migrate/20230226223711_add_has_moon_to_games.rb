class AddHasMoonToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :has_moon, :string
    add_column :games, :has_cali, :string
  end
end
