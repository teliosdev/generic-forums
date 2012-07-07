class Rope < ActiveRecord::Base
  belongs_to :board, :inverse_of => :ropes, :counter_cache => true
  belongs_to :user, :inverse_of => :ropes, :counter_cache => true
  has_many :posts, :inverse_of => :rope
  attr_accessible :title, :board, :user, :board_id, :user_id
end
