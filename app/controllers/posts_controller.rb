class PostsController < ApplicationController
  helper :users

  before_filter :load_board_thread, :handle_breadcrumbs, :check_permissions

  def index
    @board   = Board.find(params[:board_id])
    @thread  = Rope.find(params[:rope_id])
    puts "THREAD OUTPUT_______________________________"
    p @thread
    @posts   = Post.where(:rope_id => @thread.id)
  end

  def new
  end

  def create
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

  def load_board_thread
    @board  = Board.find(params[:board_id])
    @thread = Rope.find(params[:rope_id])
  end

  def handle_breadcrumbs
    @breadcrumbs.add :name => @board.name, :link => url_for(@board)
    @breadcrumbs.add :name => @thread.title, :link => url_for([@board, @thread])
  end

  def check_permissions
    @thread_permission = resolve(@thread, @user)
    raise StandardError, "Unable to Read Thread" unless @thread_permission.read?
  end
end
