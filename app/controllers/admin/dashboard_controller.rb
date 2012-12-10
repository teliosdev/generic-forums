class Admin::DashboardController < ApplicationController
	layout "admin"

	def index
    current = Time.now
    future = Time.new current.year, current.month, current.day, current.hour
    @post_history = Rails.cache.fetch(:post_history, :expires => future) do
      Post.where("created_at > ?", 24.hours.ago).chunk { |post| post.created_at.hour }.map { |h,ps| [h, ps.count] }
    end
	end
end
