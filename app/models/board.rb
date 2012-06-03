class Board < ActiveRecord::Base
  attr_accessible :name, :sub, :pos, :parent_id
  has_many :permissions, :class_name => "BoardPermission", :foreign_key => :remote_id, :inverse_of => :board
end
