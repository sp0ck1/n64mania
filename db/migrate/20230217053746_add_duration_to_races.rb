class AddDurationToRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :races, :duration, :integer
  end
end
