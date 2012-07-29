class BoardsController < ApplicationController

	before_filter :load_board

  def index
  end

  def show
    @children = Board.where(:parent_id => @board.id)
  end

  protected

  def load_board
  	if params[:id] and not params[:board_id]
  		@board = Board.find params[:id]
  	elsif params[:board_id]
  		@board = Board.find params[:board_id]
  	else
  		@boards = Board.scoped
  	end
  end
end
