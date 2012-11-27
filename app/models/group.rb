class Group < ActiveRecord::Base
  attr_accessible :name, :avatar_size, :title
  has_and_belongs_to_many :users, :join_table => "user_groups"
  has_many :permissions, :inverse_of => :group

  validates :name,
    :length   => { :in => 3..20 },
    :presence => true

  def title
    read_attribute(:title) || read_attribute(:name).downcase
  end
end
