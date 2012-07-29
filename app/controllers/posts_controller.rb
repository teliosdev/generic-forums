class PostsController < ApplicationController
  helper :users

  before_filter :handle_breadcrumbs

  def index
    #puts "THREAD OUTPUT_______________________________"
    #p @thread
    @posts   = Post.where(:rope_id => @rope.id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create params[:post]
    @post.rope = @rope
    @post.user = @user
    unless @post.save
      render "new"
    else
      redirect_to board_rope_path(@post.rope)
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
end
