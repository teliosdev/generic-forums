class RopesController < ApplicationController
  load_and_authorize_resource :board
  load_and_authorize_resource
  include ApplicationHelper

  before_filter :load_board, :only => [:index, :show]
  before_filter :handle_breadcrumbs

  def index
    @threads = Rope.where(:board_id => @board)
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

end
