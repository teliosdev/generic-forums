class AddStuffToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :posts_count, :default => 0
      t.integer :ropes_count, :default => 0
      t.text    :options
      t.references :primary_group
    end
  end
end
