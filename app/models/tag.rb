class Tag < ActiveRecord::Base
  has_and_belongs_to_many :ropes
  attr_accessible :name

  validates :name,
    :presence => true,
    :format   => { :with => /\A[A-Za-z0-9\-\_]+\z/ },
    :length   => { :in   => 3..20 },
    :uniqueness => true
end
