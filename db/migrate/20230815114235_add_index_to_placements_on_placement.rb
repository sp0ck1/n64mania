class AddIndexToPlacementsOnPlacement < ActiveRecord::Migration[6.0]
  def change
    add_index :placements, [:race_id, :placement]
  end
end
