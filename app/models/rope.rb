class Rope < ActiveRecord::Base
  belongs_to :board, :inverse_of => :ropes, :counter_cache => true
  belongs_to :user, :inverse_of => :ropes, :counter_cache => true
  has_many :posts, :inverse_of => :rope
  has_many :permissions, :foreign_key => :remote_id, :inverse_of => :remote
  attr_accessible :title, :board, :user, :board_id, :user_id
end
