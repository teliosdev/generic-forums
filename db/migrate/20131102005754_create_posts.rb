class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :rope_id
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
