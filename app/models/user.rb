class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  has_and_belongs_to_many :groups
  has_many :permissions, through: :groups
  has_many :ropes
  has_many :posts

  validates :name, format: { with: /\A[A-Za-z0-9\-\_]+\z/ },
    length: { within: 3..20 }, presence: true, uniqueness: true

  include Gravtastic
  has_gravatar filetype: :png, default: :identicon, rating: :pg,
    secure: true

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

  def online?
    if current_sign_in_at and
      current_sign_in_at.between?(Time.now.utc, 30.minutes.ago)
      true
    else
      false
    end
  end

end
