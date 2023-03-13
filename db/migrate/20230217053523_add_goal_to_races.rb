class AddGoalToRaces < ActiveRecord::Migration[6.0]
  def change
    add_column :races, :goal, :string
  end
end
