class AddAvatarSizeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :avatar_size, :string
  end
end
