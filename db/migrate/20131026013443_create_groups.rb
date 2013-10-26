class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    add_reference :permissions, :group, index: true
  end
end
