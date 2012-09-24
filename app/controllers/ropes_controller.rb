class RopesController < ApplicationController

  include ApplicationHelper

  before_filter :load_board, :only => [:index, :show]
  before_filter :handle_breadcrumbs
  before_filter :check_permissions, :only => [:show]

  def index
    puts "DEBUG" + ("_" * 20)
    p @board.id
    p params[:page]
    p AppConfig.user_options.posts_per_page.default
    @threads = Rope.where(:board_id => @board.id, :is_ghost => false)
      .page(params[:page]).per(@user.per_page :threads) #(:page => params[:page], :per_page => @user.per_page(:threads))
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
    render 'error/404' unless @thread and can? :read, @thread
  end

end
