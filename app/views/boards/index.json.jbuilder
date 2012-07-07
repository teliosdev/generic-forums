ary = []
@boards.find_each do |board|
  ary.push board if resolve_board(board, @user).read?
end

json.array!(ary) do |json, board|
  #json.id        board.id
  #json.name      board.name
  #json.parent_id board.parent_id
  #json.desc      board.sub
  json.(board, :id, :name, :parent_id, :sub)
end
