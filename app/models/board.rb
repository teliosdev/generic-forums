class Board < ActiveRecord::Base
  attr_accessible :name, :sub, :pos, :parent_id
  has_many :permissions, :foreign_key => :remote_id, :inverse_of => :remote, :conditions => { :type => "Board" }
  has_many :ropes, :inverse_of => :board
  has_many :posts, :through => :ropes
  belongs_to :parent, :class_name => "Board"

  def to_param
    super unless AppConfig.parameterization.board
    "#{id}-#{name}"
  end
end
