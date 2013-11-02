class AddPostsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :posts_count, :integer
  end
end
