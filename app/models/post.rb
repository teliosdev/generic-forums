class Post < ActiveRecord::Base
  belongs_to :user, :inverse_of => :posts, :counter_cache => true
  belongs_to :rope, :inverse_of => :posts, :counter_cache => true
  attr_accessible :body, :points, :rope, :rope_id, :user, :user_id
end
