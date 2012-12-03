class User < ActiveRecord::Base

  attr_accessible :email, :name, :avatar, :password, :password_confirmation, :options
  serialize :options
  default_scope order("created_at DESC")

  # Relationships
  has_and_belongs_to_many :groups, :join_table => "user_groups"
  has_many :permissions, :through => :groups, :inverse_of => :group
  has_many :ropes, :inverse_of => :user
  has_many :posts, :inverse_of => :user
  belongs_to :primary_group, :class_name => "Group"


  # Validations
  validates :name,
    :presence => true,
    :format => { :with => /\A[a-zA-Z0-9\-\_]+\Z/ },
    :length => { :in => 3..20 },
    :uniqueness => true

  validates_presence_of :primary_group

  # Authentic
  acts_as_authentic do |c|
    c.session_class        Session
    c.validate_email_field true
    c.email_field          :email
    c.logged_in_timeout    AppConfig.online
    c.login_field          :name
    c.crypto_provider      Authlogic::CryptoProviders::BCrypt
    c.merge_validates_uniqueness_of_login_field_options :case_sensitive => true
  end

  # Paperclip
  has_attached_file :avatar,
    :path => ":rails_root/public/:attachment/:id/:hash.:content_type_extension",
    :url  => "/:attachment/:id/:hash.:content_type_extension",
    :hash_secret => GenericForums::Application.config.secret_token,
    :default_url => "/:attachment/missing.png",
    :storage => :filesystem, :styles => lambda { |attachment|
      {
        :default => attachment.instance.primary_group.avatar_size,
        :thumbnail => "32x32"
      }
    }, :default_style => :default

  validates_attachment :avatar,
    :content_type => { :content_type => AppConfig.avatars.allowed_content_types },
    :size         => { :less_than => AppConfig.avatars.max_size }

  # Methods
  def self.guest
    find 0
  end

  def guest?
    id == 0
  end

  def per_page(type)
    self.options[:"#{type}_per_page"]
  end

  def options
    @_opts ||= OptionsAccessor.new read_attribute(:options), self
  end

  def options= op
    @_opts = nil
    write_attribute(:options, op)
  end
end

class OptionsAccessor
  def initialize(opts, user)
    @opts  = opts
    @_user = user
  end

  def [] name
    if @opts and @opts[name]
      @opts[name]
    else
      AppConfig.user_options.public_send(name)
    end
  end

  def []= name, value
    @opts[name] = value
    user.update_attribute(:options, @opts)
  end
end
