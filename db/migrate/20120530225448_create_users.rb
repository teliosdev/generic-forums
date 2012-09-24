class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.primary_key :id
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :avatar

      t.timestamps
    end
  end
end
