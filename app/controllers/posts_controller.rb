class PostsController < ApplicationController
  helper :users

  before_filter :handle_breadcrumbs
  before_filter :check_permissions

  def index
    #puts "THREAD OUTPUT_______________________________"
    #p @thread
    @posts   = Post.includes(:user).where(:rope_id => @rope.id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create params[:post]
    puts "POST_BODY" + ("_"*20)
    puts @post.body
    puts "DONE_____" + ("_"*20)
    @post.rope = @rope
    @post.user = @user
    unless @post.save
      render "new"
    else
      redirect_to board_rope_posts_path(@post.rope.board.id, @post.rope.id)
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  protected

  def handle_breadcrumbs
    @board   = Board.find(params[:board_id])
    @rope    = Rope.find(params[:rope_id])
    @breadcrumbs.add :name => @board.name, :link => url_for(@board)
    @breadcrumbs.add :name => @rope.title, :link => url_for([@board, @rope])
  end

  def check_permissions
    render 'error/404' unless can? :read, @board
    render 'error/404' unless can? :read, @rope
  end
end
