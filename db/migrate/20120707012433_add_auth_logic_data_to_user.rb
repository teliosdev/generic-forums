class AddAuthLogicDataToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :crypted_password,    :null => false, :default => ""
      t.string :password_salt,       :null => false, :default => ""
      t.string :persistence_token,   :null => false, :default => ""
      t.string :single_access_token, :null => false, :default => ""
      t.string :perishable_token,    :null => false, :default => ""

      t.integer  :login_count,       :null => false, :default => 0
      t.integer  :failed_login_count,:null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string   :current_login_ip
      t.string   :last_login_ip
    end
    remove_column :users, :password_digest
  end
end
