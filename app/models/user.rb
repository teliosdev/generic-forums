class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :lockable, :timeoutable
  attr_accessor :login

  attr_accessible :email, :username, :avatar, :password,
    :password_confirmation, :options, :remember_me, :login

  serialize :options

  default_scope order("created_at DESC")

  # Relationships
  has_and_belongs_to_many :groups, :join_table => "user_groups"
  has_many :permissions, :through => :groups, :inverse_of => :group
  has_many :ropes, :inverse_of => :user
  has_many :posts, :inverse_of => :user
  belongs_to :primary_group, :class_name => "Group"


  # Validations
  validates :username,
    :presence => true,
    :format => { :with => /\A[a-zA-Z0-9\-\_]+\Z/ },
    :length => { :in => 3..20 },
    :uniqueness => true

  validates_presence_of :primary_group

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
    :content_type => {
      :content_type => AppConfig.avatars.allowed_content_types
    },
    :size         => { :less_than => AppConfig.avatars.max_size }

  is_impressionable :counter_cache => true

  has_option :options

  # Methods
  def guest?
    id == 0
  end

  def logged_in?
    timedout? AppConfig.online.ago
  end

  def per_page(type)
    self.options[:"#{type}_per_page"] || AppConfig.user_options[:"#{type}_per_page"]
  end

  def name
    username
  end

  def self.guest
    find 0
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
