class PostsController < ApplicationController
  helper :users

  include PostsHelper

  before_filter :handle_breadcrumbs
  before_filter :check_permissions

  def index
    #puts "THREAD OUTPUT_______________________________"
    #p @thread
    @posts   = Post.includes(:user).where(:rope_id => @rope)
      .page(params[:page]).per(if true then 20 else @user.per_page(:posts) end)
  end

  def new
    return render "error/400" unless can?(:post, @rope)
    @post = Post.new
    if params[:parent_id]
      @post.parent_id = params[:parent_id]
      @parent_post = Post.find @post.parent_id
      @post.body = q(@parent_post)
    end
  end

  def create
    return render "error/400" unless can?(:post, @rope)
    @post = Post.create params[:post]
    @post.rope = @rope
    @post.user = @user
    unless @post.save
      render "new"
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
    return render "error/400" unless can?(:edit_post, @rope) or (@post.user == @user and can?(:edit_own_post, @rope))
  end

  def update
    @post = Post.find params[:id]
    return render "error/400" unless can?(:edit_post, @rope) or (@post.user == @user and can?(:edit_own_post, @rope))
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
    return render "error/400" unless can?(:delete_post, @rope) or (@post.user == @user and can?(:edit_own_post, @rope))
    if @rope.posts.size == 1
      @rope.destroy
      redirect_to board_ropes_path(@rope.board_id)
    else
      @post.destroy
      redirect_to board_rope_posts_path(@rope.board_id, @rope.id)
    end
  end

  protected

  def handle_breadcrumbs
    @board   = Board.find(params[:board_id])
    @rope    = Rope.find(params[:rope_id])
    @breadcrumbs.add :name => @board.name, :link => board_ropes_path(@board)
    @breadcrumbs.add :name => @rope.title, :link => board_rope_posts_path(@board, @rope)
  end

  def check_permissions
    render 'error/400' unless can? :read, @board
    render 'error/400' unless can? :read, @rope
  end
end
