class ChangeToRemoteType < ActiveRecord::Migration
  def change
    remove_column :permissions, :type
    add_column :permissions, :remote_type, :string
  end
end
