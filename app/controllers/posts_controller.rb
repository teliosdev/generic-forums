class PostsController < ApplicationController

  def new
    @rope = Rope.find(params[:rope_id])

    current_ability.authorize! :post, @rope

    @post = Post.new rope_id: @rope.id
  end
end
