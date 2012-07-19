json.array!(@boards) do |json, board|
  json.partial! "partials/board_info", :board => board
end
