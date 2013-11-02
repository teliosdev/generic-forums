class AddPostsCountToRope < ActiveRecord::Migration
  def change
    add_column :ropes, :posts_count, :integer
  end
end
