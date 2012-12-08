class Permission < ActiveRecord::Base
  attr_accessible :group_id, :remote_id, :action, :group, :negate
  belongs_to :group
  has_many :users, :through => :group
  belongs_to :remote, :polymorphic => true

  self.inheritance_column = '_type'

  validates :group_id,
    :presence     => true,
    :numericality => true

  validates :remote_id,
    :presence     => true,
    :numericality => true

end

#class PostPermission < Permission
#  belongs_to :post, :foreign_key => :remote_id
#end

#class ThreadPermission < Permission
#  belongs_to :thread, :foreign_key => :remote_id
#end
