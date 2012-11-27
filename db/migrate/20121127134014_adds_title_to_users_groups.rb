class AddsTitleToUsersGroups < ActiveRecord::Migration
  def change
    add_column :users,  :title, :string
    add_column :groups, :title, :string
    add_column :groups, :name_color, :string
  end
end
