class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.primary_key :id
      t.string :name
      t.integer :parent_id
      t.integer :position
      t.text :sub

      t.timestamps
    end
  end
end
