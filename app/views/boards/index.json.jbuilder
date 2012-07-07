ary = []
@boards.find_each do |board|
  ary.push board if resolve_board(board, @user).read?
end

json.array!(ary) do |json, board|
  json.partial! "partials/board_info", :board => board
end
