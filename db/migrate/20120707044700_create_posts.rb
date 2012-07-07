class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.references :user
      t.references :rope
      t.decimal :points, :scale => 2, :precision => 16, :default => 0.00 # 16 because its the max SQLite3 can store it as

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :rope_id
  end
end
