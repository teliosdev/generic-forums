class Post < ActiveRecord::Base
  belongs_to :user, :inverse_of => :posts, :counter_cache => true
  belongs_to :rope, :inverse_of => :posts, :counter_cache => true
  has_one :board, :through => :rope
  has_many :children, :class_name => "Post", :foreign_key => :parent_id, :inverse_of => :parent
  belongs_to :parent, :class_name => "Post", :foreign_key => :parent_id, :inverse_of => :children
  has_many :permissions, :as => :remote
  attr_accessible :body, :format, :parent_id

  has_paper_trail
  has_ghost

  validates_presence_of :body, :format, :rope_id, :user_id
  validates :format, :inclusion => { :in => ::Formatter::Register.format_list.map { |x| x.to_s } }

  default_scope order("created_at ASC")

  def page(per_page = AppConfig.user_options.posts_per_page, order = :id)
    position = self.class.where(:rope_id => read_attribute(:rope_id)).where("#{order} <= ?", self.send(order)).size
    (position.to_f/per_page).ceil
  end

  def ghost(user)
    if self.user == user
      self.rope.try(:ghost, user).try(:posts).try(:last)
    else
      self.rope.try(:ghost, user).try(:posts).try(:first)
    end || nil
  end

  def ghost?
    rope.ghost?
  end

end
