json.partial! "partials/board_info", :board => @board

json.threads(@threads) do |json, thread|
  json.(thread, :id, :title)
  json.url json_url([@board, thread])
  json.user do |json|
    json.(thread.user, :id, :name)
  end
end
