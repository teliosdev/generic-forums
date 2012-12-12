class Admin::DashboardController < ApplicationController
	layout "admin"

	def index
    current = Time.now
    future = Time.new current.year, current.month, current.day, current.hour
    @post_history = Rails.cache.fetch(:post_history, :expires => future) do
      count = Post.where("created_at > ?", 24.hours.ago).chunk { |post| post.created_at.hour }.map { |h,ps| [h, ps.count] }
      h = {}
      count.each do |c|
        h[c[0]] = c[1]
      end
      24.times do |i|
        h[i] ||= 0
      end
      h.sort
    end
	end
end
