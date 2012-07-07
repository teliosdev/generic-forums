class User < ActiveRecord::Base
  #has_secure_password
  attr_accessible :email, :name, :avatar, :password, :password_confirmation
  has_and_belongs_to_many :groups, :join_table => "user_groups"
  has_many :permissions, :through => :groups, :inverse_of => :group

  validates :name,
    :presence => true,
    :format => { :with => /\A[a-zA-Z0-9\-\_]+\Z/, :message => "has non-alphanumeric characters" },
    :length => { :in => 3..20 },
    :uniqueness => true

  #validates_presence_of :password, :on => :create

  acts_as_authentic do |c|
    c.session_class        Session
    c.validate_email_field true
    c.email_field          :email
    c.logged_in_timeout    1.hour
    c.login_field          :name
    c.crypto_provider      Authlogic::CryptoProviders::BCrypt
  end

  #def self.authenticate(identifier, password)
  #  user = find_by_name(identifier) || find_by_email(identifier)
  #  user.try :authenticate, password
  #end
end
