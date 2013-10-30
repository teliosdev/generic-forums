class AddCollectionFlagToMeta < ActiveRecord::Migration
  def change
    add_column :meta, :collection, :boolean, default: false
  end
end
