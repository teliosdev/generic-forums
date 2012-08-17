class Post < ActiveRecord::Base
  belongs_to :user, :inverse_of => :posts, :counter_cache => true
  belongs_to :rope, :inverse_of => :posts, :counter_cache => true
  attr_accessible :body, :points, :rope, :rope_id, :user, :user_id, :format
  before_save :calculate_points

  validates_presence_of :body, :format, :rope_id, :user_id

  protected

  include PostEvalHelper

  def calculate_points
    points = (Eval.new.score(body) || [0,0])[1].round(2)
    write_attribute(:points, points)
    user.update_attribute(:points,
      user.points +=
      points
    )
    nil
  end
end
