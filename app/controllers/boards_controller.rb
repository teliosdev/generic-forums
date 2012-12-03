class BoardsController < ApplicationController

	before_filter :load_board
  before_filter :check_permissions, :only => [:show]
  helper :posts

  def index
  end

  def show
    @children = Board.where(:parent_id => @board.id).select do |c|
      can? :read, c
    end
  end

  protected

  def load_board
  	if params[:id] and not params[:board_id]
  		@board = Board.find params[:id]
  	elsif params[:board_id]
  		@board = Board.find params[:board_id]
  	else
  		@boards = Board.scoped.select do |b|
        can? :read, b
      end
  	end
  end

  def check_permissions
    error(404) unless can? :read, @board
  end
end
