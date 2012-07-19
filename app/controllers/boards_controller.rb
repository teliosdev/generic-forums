class BoardsController < ApplicationController
  load_and_authorize_resource

  def index
    p instance_variables.sort
  end

  def show
    @children = Board.where(:parent_id => @board.id)
  end
end
