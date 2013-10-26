class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  has_and_belongs_to_many :groups
  has_many :permissions, through: :groups

  include Gravtastic
  has_gravatar
end
