class RenameStringColumnToNameInGenreTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :genres, :string, :name
  end
end
