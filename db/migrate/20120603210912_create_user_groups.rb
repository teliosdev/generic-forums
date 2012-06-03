class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.primary_key :id
      t.references :user
      t.references :group
    end
  end
end
