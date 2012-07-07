class BoardsController < ApplicationController
  def index
    @boards = Board.scoped
  end

  def show
    @board = Board.find_by_id params[:id]
    unless @board
      flash.now[:error] = "Board #{params[:id].to_s} does not exist."
      render 'error/404'
    end
    @children = Board.where(:parent_id => @board.id)
  end
end
