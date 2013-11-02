class Rope < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  has_many :posts
  has_one :last_post, -> { order 'created_at DESC' }, class_name: "Post"

  is_impressionable counter_cache: true
  include Shared::Metable
end
