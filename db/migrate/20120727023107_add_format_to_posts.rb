class AddFormatToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :format, :string, :default => "markdown"
  end
end
