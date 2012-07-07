class PostsController < ApplicationController

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
end
