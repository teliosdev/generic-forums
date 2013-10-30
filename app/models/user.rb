class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  before_create :set_default_groups

  has_and_belongs_to_many :groups
  has_many :permissions, through: :groups

  include Gravtastic
  has_gravatar

  private

  def set_default_groups
    return unless groups.empty?
    ActiveRecord::Base.transaction do
      Group.where(
          name: [Setting.users.default_groups].flatten
        ).each do |group|
        groups << group
      end
    end
  end
end
