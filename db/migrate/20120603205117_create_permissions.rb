class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.primary_key :id
      t.integer :remote_id
      t.string :action
      t.integer :group_id
      t.string :type

      t.timestamps
    end
  end
end
