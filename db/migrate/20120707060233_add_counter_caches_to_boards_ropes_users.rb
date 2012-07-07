class AddCounterCachesToBoardsRopesUsers < ActiveRecord::Migration
  def change
    add_column :users, :posts_count, :integer, :default => 0
    add_column :users, :ropes_count, :integer, :default => 0
    add_column :boards, :ropes_count, :integer, :default => 0
    add_column :boards, :posts_count, :integer, :default => 0
    add_column :ropes,  :posts_count, :integer, :default => 0
  end
end
