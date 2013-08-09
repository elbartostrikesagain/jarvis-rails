class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name
      t.string :type
      t.text :static_data
      t.text :api
      t.string :module

      t.timestamps
    end
  end
end
