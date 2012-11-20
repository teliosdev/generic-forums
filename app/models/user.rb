class User < ActiveRecord::Base
  #has_secure_password
  attr_accessible :email, :name, :avatar, :password, :password_confirmation, :options
  has_and_belongs_to_many :groups, :join_table => "user_groups"
  has_many :permissions, :through => :groups, :inverse_of => :group
  has_many :ropes, :inverse_of => :user
  has_many :posts, :inverse_of => :user

  serialize :options

  validates :name,
    :presence => true,
    :format => { :with => /\A[a-zA-Z0-9\-\_]+\Z/ },
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

  def self.guest
    find 0
  end

  def guest?
    id == 0
  end

  def per_page(type)
    if read_attribute(:options) and (o = self.options["#{type}_per_page".to_sym])
      o
    else
      AppConfig.user_options.public_send("#{type}_per_page")
    end
  end

  #def self.authenticate(identifier, password)
  #  user = find_by_name(identifier) || find_by_email(identifier)
  #  user.try :authenticate, password
  #end
end
