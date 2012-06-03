class Group < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :users, :join_table => "user_groups"
  has_many :permissions, :inverse_of => :group

  validates :name,
    :length   => { :in => 3..20 },
    :presence => true
end
