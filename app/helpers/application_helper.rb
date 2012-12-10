module ApplicationHelper
  def json_url(record)
    polymorphic_url record, :format => :json, :routing_type => :path
  end

  def board_breadcrumbs(board)
    breadc = []
    #breadc.push :name => board.name, :link => url_for(board)
    board_list(board).each do |b|
      breadc.push :name => b.name, :link => board_ropes_path(b)
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

  # normalize newlines AND escape HTML?  what is this heresay!
  def fix(str)
    str.gsub!(/(\r\n|\n\r|\r|\n)/, "\n") unless params[:nowsfix]
  end
end
