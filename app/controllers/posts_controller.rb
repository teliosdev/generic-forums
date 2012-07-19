class PostsController < ApplicationController
  helper :users
  load_and_authorize_resource :board
  load_and_authorize_resource :rope

  before_filter :handle_breadcrumbs

  def index
    #@board   = Board.find(params[:board_id])
    #@thread  = Rope.find(params[:rope_id])
    #puts "THREAD OUTPUT_______________________________"
    #p @thread
    @posts   = Post.where(:rope_id => @rope.id)
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

  def handle_breadcrumbs
    @breadcrumbs.add :name => @board.name, :link => url_for(@board)
    @breadcrumbs.add :name => @rope.title, :link => url_for([@board, @rope])
  end
end
