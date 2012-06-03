class Permission < ActiveRecord::Base
  attr_accessible :group_id, :remote_id, :permissions
  belongs_to :group
  has_many :users, :through => :group

  validates :permissions,
    :format   => { :with => /\A[A-Z]*\Z/ },
    :length   => { :in   => 0..20        },
    :presence => true

  validates :group_id,
    :presence     => true,
    :numericality => true

  validates :remote_id,
    :presence     => true,
    :numericality => true

  def create?
    permissions.include? "C"
  end

  def read?
    permissions.include? "R"
  end

  def update?
    permissions.include? "U"
  end

  def delete?
    permissions.include? "D"
  end
end

#class PostPermission < Permission
#  belongs_to :post, :foreign_key => :remote_id
#end

#class ThreadPermission < Permission
#  belongs_to :thread, :foreign_key => :remote_id
#end
