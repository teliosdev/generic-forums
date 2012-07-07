class CreateRopes < ActiveRecord::Migration
  def change
    create_table :ropes do |t|
      t.string :title
      t.references :board
      t.references :user

      t.timestamps
    end
    add_index :ropes, :board_id
    add_index :ropes, :user_id
  end
end
