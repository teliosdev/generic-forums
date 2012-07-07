json.partial! "partials/board_info", :board => @board

json.children(@children) do |json, child|
  json.(child, :id, :name, :parent_id, :sub)
  json.url json_url(child)
  json.threads_url "/boards/#{child.id}/threads.json"
end
