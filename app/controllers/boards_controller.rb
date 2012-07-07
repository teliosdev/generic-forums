class BoardsController < ApplicationController
  helper :application
  include ApplicationHelper

  def index
    @boards = []
    p methods
    Board.find_in_batches do |boards|
      boards.reject! { |b| resolve(b, @user).read? }
      @boards.push *boards
    end
  end

  def show
    @board = Board.find params[:id]
    @children = Board.where(:parent_id => @board.id)
  end
end
