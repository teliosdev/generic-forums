class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.string :remote_type

      t.timestamps
    end

    add_column :categories, :meta_id, :integer
    add_index :categories, :meta_id
  end
end
