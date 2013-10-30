class AddRemoteIdToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :remote_id, :integer
  end
end
