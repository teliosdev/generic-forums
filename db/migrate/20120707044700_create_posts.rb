class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.references :user
      t.references :rope

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :rope_id
  end
end
