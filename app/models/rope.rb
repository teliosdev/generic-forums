class Rope < ActiveRecord::Base

  # Relationships
  belongs_to :board, :inverse_of => :ropes, :counter_cache => true
  belongs_to :user, :inverse_of => :ropes, :counter_cache => true
  has_many :posts, :inverse_of => :rope, :dependent => :destroy
  has_many :permissions, :foreign_key => :remote_id, :inverse_of => :remote,
           :conditions => { :type => "Rope" }, :dependent => :destroy
  has_one :main_post, :class_name => Post, :validate => false
  has_and_belongs_to_many :tags

  # Others
  attr_accessible :title, :main_post_attributes
  accepts_nested_attributes_for :main_post
  serialize :ghost_data

  validates :title, :presence => true

  # Scope
  default_scope order("updated_at DESC")

  def ghost
    @ghost_thread ||= self.class.where({
        :board_id => read_attribute(:board_id),
        :is_ghost => true,
        :ghost_data => (read_attribute(:ghost_data) || {})
      }).first || self
  end

  def to_param
    return super unless AppConfig.parameterization.thread
    "#{id}-#{title.parameterize}"
  end
end
