class AddPrimaryGroupToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :primary_group
    end
    # add_column :users, :primary_group, :references
  end
end
