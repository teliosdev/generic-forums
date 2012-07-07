class RopesController < ApplicationController
  def index
    @board   = Board.find(params[:board_id])
    @threads = Rope.where(:board_id => @board)
  end

  def show
    @board   = Board.find(params[:board_id])
    @thread  = Rope.find(params[:id])
  end
end
