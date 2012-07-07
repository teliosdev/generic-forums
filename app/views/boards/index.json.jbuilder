ary = []
@boards.find_each do |board|
  ary.push board if resolve_board(board, @user).read?
end

json.array!(ary) do |json, board|
  json.(board, :id, :name, :parent_id, :sub)
  json.url json_url(board)
end
