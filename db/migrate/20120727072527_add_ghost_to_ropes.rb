class AddGhostToRopes < ActiveRecord::Migration
  def change
    add_column :ropes, :ghost, :boolean
  end
end
