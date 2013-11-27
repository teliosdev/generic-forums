class Post < ActiveRecord::Base
  belongs_to :rope, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true

  belongs_to :parent, foreign_key: "reply_to", class_name: "Post"
  has_many :replies, foreign_key: "reply_to", class_name: "Post"

  def formatted(options = {})
    GenericDataFormatter.format(format, body, options)
  end

  def page(order = :id)
    position = Post.where(rope_id: rope_id).
      where("#{order} < ?", read_attribute(order)).size

    position.fdiv(Setting.threads.per_page).ceil
  end
end
