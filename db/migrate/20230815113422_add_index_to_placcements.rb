class AddIndexToPlaccements < ActiveRecord::Migration[6.0]
  def change
    add_index :placements, [:race_id, :player_id]
  end
end
