class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.primary_key :id
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :avatar
      t.decimal :points, :scale => 2, :percision => 16, :default => 0.00

      t.timestamps
    end
  end
end
