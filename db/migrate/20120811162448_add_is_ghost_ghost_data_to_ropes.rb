class AddIsGhostGhostDataToRopes < ActiveRecord::Migration
  def change
    add_column :ropes, :is_ghost, :boolean, :default => false
    add_column :ropes, :ghost_data, :text
  end
end
