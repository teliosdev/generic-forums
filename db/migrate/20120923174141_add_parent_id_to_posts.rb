class AddParentIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :parent_id, :integer
    add_index  :posts, :parent_id
  end
end
