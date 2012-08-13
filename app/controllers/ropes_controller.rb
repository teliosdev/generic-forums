class RopesController < ApplicationController

  include ApplicationHelper

  before_filter :load_board, :only => [:index, :show]
  before_filter :handle_breadcrumbs
  before_filter :check_permissions, :only => [:show]

  def index
    @threads = Rope.where(:board_id => @board.id).select do |thread|
      can?(:read, thread) and not thread.is_ghost
    end
  end

  def show
    @thread  = Rope.find(params[:id])
  end

  protected

  def load_board
    @board   = Board.find(params[:board_id])
  end

  def handle_breadcrumbs
    board_breadcrumbs(@board).each do |b|
      @breadcrumbs.add b
    end
  end

  def check_permissions
    render 'error/404' unless can? :read, @board
    render 'error/404' unless can? :read, @thread
  end

end
