class AddDescriptionToRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :races, :description, :string
  end
end
