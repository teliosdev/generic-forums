json.board do |json|
  json.(board, :id, :name, :parent_id, :sub)
  json.url json_url(board)
  json.thread_url "/board/#{board.id}/threads.json"
end
