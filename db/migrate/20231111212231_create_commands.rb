class CreateCommands < ActiveRecord::Migration[6.0]
  def change
    create_table :commands do |t|
      t.string :command
      t.string :text
      t.string :author
      t.timestamps
    end
  end
end
