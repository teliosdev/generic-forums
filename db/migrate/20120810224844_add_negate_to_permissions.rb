class AddNegateToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :negate, :boolean, :default => false

    add_index  :permissions, :remote_id
  end
end
