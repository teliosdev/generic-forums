class CreateRopes < ActiveRecord::Migration
  def change
    create_table :ropes do |t|
      t.integer :user_id
      t.integer :meta_id
      t.integer :category_id
      t.string :title

      t.timestamps
    end
  end
end
