class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :avatar, :password_confirmation
  has_and_belongs_to_many :groups, :join_table => "user_groups"
  has_many :permissions, :through => :groups, :inverse_of => :group

  validates :name,
    :presence => true,
    :format => { :with => /\A[a-zA-Z0-9\-\_]+\Z/, :message => "has non-alphanumeric characters" },
    :length => { :in => 3..20 },
    :uniqueness => true
  validates :email,
    :presence => true,
    :format => { :with => /\A.*?\@.*?\..{2,5}\Z/, :message => "is invalid" }

  validates_presence_of :password, :on => :create


    def self.authenticate(identifier, password)
      user = find_by_name(identifier) || find_by_email(identifier)
      user.try :authenticate, password
    end
end
