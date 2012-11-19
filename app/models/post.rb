class Post < ActiveRecord::Base
  belongs_to :user, :inverse_of => :posts, :counter_cache => true
  belongs_to :rope, :inverse_of => :posts, :counter_cache => true
  has_one :board, :through => :rope
  has_many :children, :class_name => "Post", :foreign_key => :parent_id, :inverse_of => :parent
  belongs_to :parent, :class_name => "Post", :foreign_key => :parent_id, :inverse_of => :children
  attr_accessible :body, :format, :parent_id

  validates_presence_of :body, :format, :rope_id, :user_id

  default_scope order("created_at")

  def page(per_page = AppConfig.user_options.posts_per_page, order = :id)
    position = self.class.where(:rope_id => read_attribute(:rope_id)).where("#{order} <= ?", self.send(order)).count
    (position.to_f/per_page).ceil
  end
end
