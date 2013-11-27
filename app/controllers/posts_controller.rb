class PostsController < ApplicationController

  def new
    @rope = Rope.find(params[:rope_id])

    current_ability.authorize! :post, @rope

    @post = Post.new rope_id: @rope.id

    if params[:reply]
      @post.reply_to = params[:reply]
    end
  end

  def create
    @rope = Rope.find(params[:rope_id])
    current_ability.authorize! :post, @rope

    @post = Post.new post_params
    @post.rope = @rope
    @post.user = current_user

    @post.save!

    redirect_to rope_path @rope
  end

  def destroy
    @post = Post.find(params[:id], include: :rope)
    @rope = @post.rope

    if params[:hard]
      current_ability.authorize! :post_destroy, @rope
      @post.destroy
    elsif params[:undelete]
      current_ability.authorize! :post_undelete, @rope
      @post.update(deleted: false)
    else
      current_ability.authorize! :post_delete, @rope
      @post.update(deleted: true)
    end

    redirect_to rope_path @rope
  end

  private

  def post_params
    params.require(:post).permit(:body, :format, :reply_to)
  end
end
