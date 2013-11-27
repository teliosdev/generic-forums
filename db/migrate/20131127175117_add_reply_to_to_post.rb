class AddReplyToToPost < ActiveRecord::Migration
  def change
    add_column :posts, :reply_to, :integer
  end
end
