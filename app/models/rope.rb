class Rope < ActiveRecord::Base
  belongs_to :board, :inverse_of => :ropes, :counter_cache => true
  belongs_to :user, :inverse_of => :ropes, :counter_cache => true
  has_many :posts, :inverse_of => :rope
  has_many :permissions, :foreign_key => :remote_id, :inverse_of => :remote, :conditions => { :type => "Rope" }
  attr_accessible :title, :board, :user, :board_id, :user_id

  default_scope order("updated_at")

  #scope

  serialize :ghost_data

  def ghost
    @ghost_thread ||= self.class.where({
        :board_id => read_attribute(:board_id),
        :is_ghost => true,
        :ghost_data => (read_attribute(:ghost_data) || {})
      }).first || self
  end
end
