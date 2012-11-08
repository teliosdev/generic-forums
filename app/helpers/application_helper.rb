module ApplicationHelper
  def json_url(record)
    polymorphic_url record, :format => :json, :routing_type => :path
  end

  def board_breadcrumbs(board)
    breadc = []
    #breadc.push :name => board.name, :link => url_for(board)
    board_list(board).each do |board|
      breadc.push :name => board.name, :link => board_ropes_path(board)
    end
    breadc
  end

  def board_list(board)
    boards = []
    boards.push board
    while cboard = board.parent
      boards.push cboard
    end
    boards
  end
end
