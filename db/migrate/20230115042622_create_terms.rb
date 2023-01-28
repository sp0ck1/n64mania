class CreateTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :terms do |t|
      t.string :name
      t.string :definition
      t.string :author

      t.timestamps
    end
  end
end
