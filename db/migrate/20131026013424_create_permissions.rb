class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :type
      t.string :permission

      t.timestamps
    end
  end
end
