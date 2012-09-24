# This migration comes from french_vanilla_engine (originally 20120923224638)
class AddPointsToModels < ActiveRecord::Migration
  def change
    add_column :users, :points, :decimal, :scale => 2, :precision => 16, :default => 0.00
    add_column :posts, :points, :decimal, :scale => 2, :precision => 16, :default => 0.00
    # 16 because its the max SQLite3 can store it as
  end
end
