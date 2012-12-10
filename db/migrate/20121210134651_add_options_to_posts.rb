class AddOptionsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :options, :text
  end
end
