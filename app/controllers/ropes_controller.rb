class RopesController < ApplicationController

  load_and_authorize_resource
  def show
    @posts = Post.where(rope_id: @rope.id).
      includes(:user).order(:updated_at).
      page(params[:page])

    impressionist @rope
    render "show", rope: @rope, posts: @posts
  end
end
