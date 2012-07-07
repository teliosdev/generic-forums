class Post < ActiveRecord::Base
  belongs_to :user, :inverse_of => :posts, :counter_cache => true
  belongs_to :rope, :inverse_of => :posts, :counter_cache => true
  attr_accessible :body, :points, :rope, :rope_id, :user, :user_id
  before_save :calculate_points

  validates_presence_of :body

  protected

  include PostEvalHelper

  def calculate_points
    write_attribute(:points, Eval.new.score(body)[1].round(2))
    user.update_attribute(:points, user.points += points)
    nil
  end
end
