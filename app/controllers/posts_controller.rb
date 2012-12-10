class PostsController < ApplicationController
  helper :users
  helper :posts

  include PostsHelper

  before_filter :handle_breadcrumbs
  before_filter :check_permissions

  def index
    #puts "THREAD OUTPUT_______________________________"
    #p @thread
    @posts   = Post.includes(:user).where(:rope_id => @rope)
      .page(params[:page]).per(if true then 20 else @user.per_page(:posts) end)
      impressionist(@rope)
  end

  def new
    return error(400) unless can?(:post, @rope)
    @post = Post.new
    if params[:parent_id]
      @post.parent_id = params[:parent_id]
      @parent_post = Post.find @post.parent_id
      @post.body = q(@parent_post)
      @post.format = @parent_post.format
    end
  end

  def create
    return error(400) unless can?(:post, @rope)
    @post = Post.create params[:post]
    @post.rope = @rope
    @post.user = @user
    unless @post.save
      if api_request?
        render "create"
      else
        render "new"
      end
    else
      @rope.touch
      redirect_to determine_path(@post) unless request.xhr?
    end
  end

  def show
    @post = Post.find params[:id]
  end

  def edit
    @post = Post.find params[:id]
    return error(400) unless can?(:edit_post, @post)
  end

  def update
    @post = Post.find params[:id]
    return error(400) unless can?(:edit_post, @post)
    @post.body   = params[:post][:body]
    @post.format = params[:post][:format]
    unless @post.save
      render "update"
    else
      redirect_to determine_path(@post) unless request.xhr?
    end
  end

  def destroy
    @post = Post.find params[:id]
    return error(400) unless can?(:delete_post, @post)
    if @rope.main_post == @post
      @post.soft_destroy
      redirect_to board_rope_posts_path(@board, @rope)
    else
      if params[:hard] and can?(:hard_delete, @post)
        @post.hard_destroy
      else
        @post.soft_destroy
      end
      redirect_to board_rope_posts_path(@board, @rope)
    end
  end

  def diff
    @post = Post.find params[:post_id]
    return error(400) unless can? :see_history, @post
    @breadcrumbs.add :name => "Post History", :link => determine_path(@post)
    if params[:v1] and params[:v2]
      @versions = @post.versions.where(Version.primary_key => [params[:v1], params[:v2]], :event => 'update')
        .except(:order).order("#{Version.primary_key} DESC")
    else
      @versions = @post.versions.where(:event => 'update').except(:order).order("#{Version.primary_key} DESC")
    end
  end

  def undelete
    @post = Post.find params[:post_id]
    return error(400) unless can? :undelete, @post
    if @post.deleted?
      @post.options[:deleted] = false
    end
    redirect_to determine_path(@post)
  end

  protected

  def handle_breadcrumbs
    @board   = Board.find(params[:board_id])
    @rope    = Rope.find(params[:rope_id])
    @breadcrumbs.add :name => @board.name, :link => board_ropes_path(@board)
    @breadcrumbs.add :name => @rope.title, :link => board_rope_posts_path(@board, @rope)
  end

  def check_permissions
    error(400) unless can? :read, @board
    error(400) unless can? :read, @rope
  end
end
