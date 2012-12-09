class Rope < ActiveRecord::Base

  # Relationships
  belongs_to :board, :inverse_of => :ropes, :counter_cache => true
  belongs_to :user, :inverse_of => :ropes, :counter_cache => true
  has_many :posts, :inverse_of => :rope, :dependent => :destroy
  has_many :permissions, :as => :remote, :dependent => :destroy
  has_one :main_post, :class_name => "Post", :validate => false
  has_and_belongs_to_many :tags

  has_ghost
  is_impressionable :counter_cache => true

  # Others
  attr_accessible :title, :main_post_attributes
  accepts_nested_attributes_for :main_post
  serialize :ghost_data

  validates :title, :presence => true, :length => { :minimum => 3 }
  validate :number_of_tags, :on => :save

  # Scope
  default_scope order("updated_at DESC")

  def ghost(user)
    @ghost_thread ||= (self.class.where({
        :board_id => read_attribute(:board_id),
        :is_ghost => true,
        :ghost_data => (read_attribute(:ghost_data) || {})
      }).first || nil)
  end

  # assumes it's being passed an array
  def set_tags(tags)
    self.tags = tags.map.each do |tag|
      Tag.find_or_create_by_name tag
    end
  end

  # create a new set of ghost posts
  def do_ghost!
    raise StandardError.new("Not a ghost rope!") unless self.is_ghost
    return if posts.size > 0
    posts.create! do |post|
      post.body   = "general post"
      post.format = "plain"
      post.user   = User.find(2)
    end
    posts.create! do |post|
      post.body   = "user's post"
      post.format = "plain"
      post.user   = User.find(2)
    end
  end

  def to_param
    return super unless AppConfig.parameterization.thread
    "#{id}-#{title.parameterize}"
  end
end
