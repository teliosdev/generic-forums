class Post < ActiveRecord::Base
  belongs_to :rope, counter_cache: true
  belongs_to :user, counter_cache: true

  def formatted(options = {})
    GenericDataFormatter.format(format, body, options)
  end
end
