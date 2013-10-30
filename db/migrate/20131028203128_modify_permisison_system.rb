class ModifyPermisisonSystem < ActiveRecord::Migration
  def change
    remove_column :permissions, :permission, :string
    remove_column :permissions, :remote_id,  :integer

    add_column :permissions, :meta_id, :integer
    add_index  :permissions, :meta_id
  end
end
